using Core;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using System;
using System.Collections.Generic;
using System.Linq;

namespace MMS.DAL
{
    public class AuditEntry
    {
        public AuditEntry(EntityEntry entry)
        {
            Entry = entry;
        }

        public EntityEntry Entry { get; }
        public string TableName { get; set; }
        public Dictionary<string, object> KeyValues { get; } = new Dictionary<string, object>();
        public Dictionary<string, object> OldValues { get; } = new Dictionary<string, object>();
        public Dictionary<string, object> NewValues { get; } = new Dictionary<string, object>();
        public string RowState { get; set; }
        public List<PropertyEntry> TemporaryProperties { get; } = new List<PropertyEntry>();

        public bool HasTemporaryProperties => TemporaryProperties.Any();

        public AuditLog ToAudit()
        {
            var currUser = AppContexts.User;
            var audit = new AuditLog
            {
                TableName = TableName,
                AuditAt = DateTime.Now.ToBD(),
                KeyValues = Util.SerializeObject(KeyValues),
                OldValues = OldValues.Count.IsZero() ? null : Util.SerializeObject(OldValues),
                NewValues = NewValues.Count.IsZero() ? null : Util.SerializeObject(NewValues),
                RowState = RowState,
                UserAgent = currUser.UserAgent,
                CreatedBy = currUser.UserId,
                CreatedAt = DateTime.Now.ToBD(),
                CreatedIP = currUser.IPAddress
            };
            return audit;
        }
    }
}
