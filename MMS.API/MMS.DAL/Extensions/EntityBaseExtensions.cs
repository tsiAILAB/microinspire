using Core;
using System;
using System.Collections.Generic;
using System.Linq;

namespace MMS.DAL
{
    public static class EntityBaseExtensions
    {
        public static void SetAuditFields(this Auditable source)
        {
            source.UpdatedBy = AppContexts.User.UserId;
            source.UpdatedAt = DateTime.Now.ToBD();
            source.UpdatedIP = AppContexts.User.IPAddress;
        }
        public static void MapToAuditFields(this Auditable source, Auditable destination)
        {
            if (source.IsNull() || destination.IsNull()) return;
            destination.CreatedBy = source.CreatedBy;
            destination.CreatedAt = source.CreatedAt;
            destination.CreatedIP = source.CreatedIP;
            destination.RowVersion = source.RowVersion;
            destination.SetUnchanged();
        }
        public static void MapToAuditFields(this IEnumerable<Auditable> source, IEnumerable<Auditable> destination)
        {
            var aSource = source.ToArray();
            var aDestination = destination.ToArray();
            for (int i = 0; i < aSource.Length; i++)
            {
                if (i > aDestination.Length) break;
                aSource[i].MapToAuditFields(aDestination[i]);
            }
        }

        public static IEnumerable<EntityBase> GetChanges(this IEnumerable<EntityBase> list)
        {
            return list.Where(item => item.IsAdded
                               || item.IsModified
                               || item.IsDeleted);
        }

        public static IEnumerable<EntityBase> GetChanges(this IEnumerable<EntityBase> list, ModelState itemState)
        {
            return list.Where(item => item.ModelState.Equals(itemState));
        }

        public static void ChangeState<T>(this List<T> list, ModelState itemState) where T : EntityBase
        {
            foreach (var item in list)
            {
                item.ModelState = itemState;
            }
        }

        public static IEnumerable<EntityBase>[] Reverse(this IEnumerable<EntityBase>[] list)
        {
            var listTemp = new IEnumerable<EntityBase>[list.Length];
            var i = 0;
            for (var index = list.Length; index >= 1; --index)
            {
                listTemp[i] = list[index - 1];
                i++;
            }
            return listTemp;
        }


        public static void AcceptChanges<T>(this List<T> list) where T : EntityBase
        {
            var items = list.Cast<EntityBase>().ToArray();
            foreach (var item in items)
            {
                switch (item.ModelState)
                {
                    case ModelState.Deleted:
                    case ModelState.Detached:
                        list.Remove((T)Convert.ChangeType(item, typeof(T)));
                        break;
                    case ModelState.Modified:
                    case ModelState.Added:
                        item.SetUnchanged();
                        break;
                }
            }
        }

        public static bool IsNull(this EntityBase obj)
        {
            return obj == null;
        }
        public static bool IsNotNull(this EntityBase obj)
        {
            return obj != null;
        }
    }
}
