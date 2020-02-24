using MMS.Core;
using Newtonsoft.Json;
using System;

namespace MMS.DAL
{
    public class AuditCreate : EntityBase
    {
        public int CreatedBy { get; set; }
        [JsonConverter(typeof(SystemDateTimeConverter))]
        public DateTime CreatedAt { get; set; }
        public string CreatedIP { get; set; }
    }
}
