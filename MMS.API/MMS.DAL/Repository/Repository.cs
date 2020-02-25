using Core;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace MMS.DAL
{
    public class Repository<TDbContext, TEntity> : IRepository<TEntity> where TDbContext : BaseDbContext where TEntity : EntityBase
    {
        private readonly TDbContext Context;
        private readonly DbSet<TEntity> entities;

        public IQueryable<TEntity> Entities => entities;

        public Repository(TDbContext context)
        {
            Context = context;
            entities = Context.Set<TEntity>();
        }

        public IQueryable<TEntity> FromSql(string sql, params object[] parameters)
        {
            return entities.FromSql(sql, parameters);
        }

        public async Task<IEnumerable<TEntity>> GetAll()
        {
            return await entities.ToListAsync();
        }

        public List<TEntity> GetAllList()
        {
            return entities.ToList();
        }

        public List<TEntity> GetAllList(Expression<Func<TEntity, bool>> predicate)
        {
            return entities.Where(predicate).ToList();
        }

        public TEntity Get(params object[] keyValues)
        {
            TEntity entity = entities.Find(keyValues);
            return entity;
        }

        public async Task<TEntity> GetAsync(params object[] keyValues)
        {
            TEntity entity = await entities.FindAsync(keyValues);
            return entity;
        }

        public async Task<List<TEntity>> GetAllListAsync()
        {
            return await entities.ToListAsync();
        }

        public async Task<List<TEntity>> GetAllListAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return await entities.Where(predicate).ToListAsync();
        }

        public TEntity Single(Expression<Func<TEntity, bool>> predicate)
        {
            return entities.Single(predicate);
        }

        public async Task<TEntity> SingleAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return await entities.SingleAsync(predicate);
        }

        public TEntity SingleOrDefault(Expression<Func<TEntity, bool>> predicate)
        {
            return entities.SingleOrDefault(predicate);
        }

        public async Task<TEntity> SingleOrDefaultAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return await entities.SingleOrDefaultAsync(predicate);
        }

        public virtual TEntity FirstOrDefault(Expression<Func<TEntity, bool>> predicate)
        {
            return entities.FirstOrDefault(predicate);
        }

        public virtual Task<TEntity> FirstOrDefaultAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return entities.FirstOrDefaultAsync(predicate);
        }

        public int Count()
        {
            return entities.Count();
        }

        public int Count(Expression<Func<TEntity, bool>> predicate)
        {
            return entities.Where(predicate).Count();
        }

        public async Task<int> CountAsync()
        {
            return await entities.CountAsync();
        }

        public async Task<int> CountAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return await entities.Where(predicate).CountAsync();
        }
        public long LongCount()
        {
            return entities.LongCount();
        }

        public long LongCount(Expression<Func<TEntity, bool>> predicate)
        {
            return entities.Where(predicate).LongCount();
        }

        public async Task<long> LongCountAsync()
        {
            return await entities.LongCountAsync();
        }

        public async Task<long> LongCountAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return await entities.Where(predicate).LongCountAsync();
        }

        public void Add(TEntity entity)
        {
            UpdateToList(entity);
            SetAudited(entity);
        }

        public void AddRange(IEnumerable<TEntity> collection)
        {
            foreach (var entity in collection)
            {
                Add(entity);
            }
        }

        public int Update<T>(object entity) where T : EntityBase
        {
            var values = new List<object>();
            var properties = entity.GetType().GetProperties().ToList();
            var query = Context.GenerateUpdateSql<T>(entity, properties);
            foreach (var property in properties)
            {
                values.Add(property.GetValue(entity));
            }
            return ExecuteSqlCommand(query, values.ToArray());
        }

        public void SaveChanges()
        {
            Context.SaveChanges();
        }

        protected virtual void AttachIfNot(TEntity entity)
        {
            if (entities.Local.Contains(entity)) return;
            entities.Attach(entity);
        }

        private void UpdateToList(TEntity entity)
        {
            switch (entity.ModelState)
            {
                case ModelState.Added:
                    entities.Add(entity);
                    break;
                case ModelState.Modified:
                case ModelState.Archived:
                    AttachIfNot(entity);
                    Context.Entry(entity).State = EntityState.Modified;
                    break;
                case ModelState.Deleted:
                    AttachIfNot(entity);
                    entities.Remove(entity);
                    break;
                default:
                    break;
            }
        }

        private void SetAudited(TEntity entity)
        {
            var currUser = AppContexts.User;
            var auEntity = entity as Auditable;
            if (auEntity.IsNull())
            {
                var auCre = entity as AuditCreate;
                if (auCre.IsNull()) return;
                auCre.CreatedBy = currUser.UserId;
                auCre.CreatedAt = DateTime.Now.ToBD();
                auCre.CreatedIP = currUser.IPAddress;
                return;
            }
            //var ent = Context.Entry(entity);
            switch (auEntity.ModelState)
            {
                case ModelState.Added:
                    auEntity.CreatedBy = currUser.UserId;
                    auEntity.CreatedAt = DateTime.Now.ToBD();
                    auEntity.CreatedIP = currUser.IPAddress;
                    auEntity.RowVersion = 1;
                    break;
                case ModelState.Modified:
                case ModelState.Archived:
                    auEntity.UpdatedBy = currUser.UserId;
                    auEntity.UpdatedAt = DateTime.Now.ToBD();
                    auEntity.UpdatedIP = currUser.IPAddress;

                    var oldVal = auEntity.RowVersion;
                    Context.Entry(entity).Property("RowVersion").OriginalValue = oldVal;
                    auEntity.RowVersion += 1;

                    //ent.Property("CreatedBy").IsModified = false;
                    //ent.Property("CreatedDate").IsModified = false;
                    //ent.Property("CreatedIP").IsModified = false;
                    break;
                default:
                    break;
            }
        }
        private void ConcurrencyCheck(TEntity entity)
        {
            var auEntity = entity as Auditable;
            if (auEntity.IsNull()) return;
            switch (auEntity.ModelState)
            {
                case ModelState.Added:
                    auEntity.RowVersion = 1;
                    break;
                case ModelState.Modified:
                case ModelState.Archived:
                    var oldVal = auEntity.RowVersion;
                    Context.Entry(entity).Property("RowVersion").OriginalValue = oldVal;
                    auEntity.RowVersion += 1;
                    break;
                default:
                    break;
            }
        }
        public T GetMaxNumber<T>(string fieldName)
        {
            var sqlHelper = Context.CreateSqlGennerator();
            var tableName = Context.GetTableName<TEntity>();
            var sql = $"SELECT {sqlHelper.IsNullFunction()}(MAX({sqlHelper.QuoteIdentifier(fieldName)}), 0) + 1 AS {sqlHelper.QuoteIdentifier("MaxNumber")} FROM {tableName}";
            var result = Context.ExecuteScalar<T>(sql);
            return result;
        }
        public int ExecuteSqlCommand(string sql, params object[] parameters)
        {
            return Context.Database.ExecuteSqlCommand(sql, parameters);
        }
    }
}