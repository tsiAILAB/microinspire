using MMS.Core;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace MMS.DAL
{
    internal static class ContextExtensions
    {
        public static string GetTableName<TEntity>(this DbContext context) where TEntity : EntityBase
        {
            var sqlHelper = context.CreateSqlGennerator();
            var mapping = context.Model.FindEntityType(typeof(TEntity)).Relational();
            var schema = mapping.Schema ?? sqlHelper.DefaultSchema();
            var tableName = string.Empty;
            if (schema.IsNotNullOrEmpty())
                schema = $"{sqlHelper.QuoteIdentifier(schema)}.";
            tableName = sqlHelper.QuoteIdentifier(mapping.TableName);
            return $"{schema}{tableName}";
        }

        public static List<string> GetKeyNames<TEntity>(this DbContext context) where TEntity : EntityBase
        {
            return context.GetKeyNames(typeof(TEntity));
        }
        public static List<string> GetKeyNames(this DbContext context, Type entityType)
        {
            return context.Model.FindEntityType(entityType).FindPrimaryKey().Properties
                .Select(x => x.Name).ToList();
        }

        public static string GenerateUpdateSql<TEntity>(this DbContext context, object entity, List<PropertyInfo> propertyList) where TEntity : EntityBase
        {
            var sqlHelper = context.CreateSqlGennerator();
            var type = typeof(TEntity);
            var tableName = context.GetTableName<TEntity>();
            var entityType = context.Model.FindEntityType(type);
            var keyFields = context.GetKeyNames(type);
            var properties = entityType.GetProperties();

            var updateColumn = new StringBuilder();
            updateColumn.Append($"UPDATE {tableName}\n");
            updateColumn.Append("\tSET\t");
            int pindex = 0;
            foreach (var param in propertyList)
            {
                if (keyFields.Contains(param.Name)) continue;
                var col = properties.FirstOrDefault(p => p.Name == param.Name);
                if (col.IsNull()) continue;
                updateColumn.Append($"{sqlHelper.QuoteIdentifier(col.Relational().ColumnName)} = @p{pindex},\n\t\t");
                pindex++;
            }
            updateColumn = updateColumn.Remove(updateColumn.Length - 4, 4);

            updateColumn.Append("\n\tWHERE\t");
            foreach (var key in keyFields)
            {
                var kProp = entity.GetType().GetProperty(key);
                if (kProp.IsNotNull())
                {
                    if (propertyList.Contains(kProp)) propertyList.Remove(kProp);
                    propertyList.Add(kProp);
                }
                updateColumn.Append($"{sqlHelper.QuoteIdentifier(key)} = @p{pindex} AND ");
                pindex++;
            }
            return updateColumn.Remove(updateColumn.Length - 5, 5).ToString();
        }

        public static DbContextOptionsBuilder UseDatabase(this DbContextOptionsBuilder optionsBuilder, string conName)
        {
            var connection = AppContexts.GetConnection(conName);
            if (connection.IsNull()) return optionsBuilder;
            if (connection.Provider == "SqlClient")
                optionsBuilder.UseSqlServer(connection.ConnectionString);            
            else
                optionsBuilder.UseSqlServer(connection.ConnectionString);
            return optionsBuilder;
        }

        public static ISqlGen CreateSqlGennerator(this DbContext context)
        {
            ISqlGen sqlGen = null;
            if (context.Database.IsSqlServer())
                return sqlGen = new SqlGen();            
            else
                return sqlGen = new OracleGen();
        }
    }
}