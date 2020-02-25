using Microsoft.EntityFrameworkCore.Storage;
using Core;
using System;
using System.Collections.Generic;

namespace MMS.DAL
{
    public sealed class UnitOfWork : IDisposable
    {
        readonly List<BaseDbContext> activeDbs;
        readonly List<IDbContextTransaction> activeTrans;
        bool tranStarted = false;
        public UnitOfWork()
        {
            activeDbs = AppContexts.GetActiveDbContexts<BaseDbContext>();
            activeTrans = new List<IDbContextTransaction>();
            BeginTrans();
        }

        private void BeginTrans()
        {
            foreach (var context in activeDbs)
            {
                if (context.IsNotNull())
                    activeTrans.Add(context.Database.BeginTransaction());
            }
            tranStarted = true;
        }
        private void Commit()
        {
            foreach (var trans in activeTrans)
            {
                trans.Commit();
            }
            tranStarted = false;
        }
        private void Rollback()
        {
            if (!tranStarted) return;
            foreach (var trans in activeTrans)
            {
                trans.Rollback();
            }
            tranStarted = false;
        }

        public static void SaveChanges()
        {
            var dbs = AppContexts.GetActiveDbContexts<BaseDbContext>();
            SaveChanges(dbs);
        }

        private static void SaveChanges(List<BaseDbContext> dbs)
        {
            foreach (var context in dbs)
            {
                if (context.IsNotNull())
                    context.SaveChanges();
            }
        }

        public void CommitChanges()
        {
            try
            {
                SaveChanges(activeDbs);
                Commit();
            }
            catch (Exception ex)
            {
                Rollback();
                throw ex;
            }
        }
        public void Dispose()
        {
            Rollback();
            foreach (var trans in activeTrans)
            {
                trans.Dispose();
            }
        }
    }
}