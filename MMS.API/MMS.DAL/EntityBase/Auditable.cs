using Core;
using Newtonsoft.Json;
using System;
using System.ComponentModel.DataAnnotations;

namespace MMS.DAL
{
    public class Auditable : EntityBase
    {
        public int CreatedBy { get; set; }
        [JsonConverter(typeof(SystemDateTimeConverter))]
        public DateTime CreatedAt { get; set; }
        public string CreatedIP { get; set; }
        [JsonIgnore]
        public int? UpdatedBy { get; set; }
        [JsonIgnore]
        public DateTime? UpdatedAt { get; set; }
        [JsonIgnore]
        public string UpdatedIP { get; set; }
        [ConcurrencyCheck]
        public short RowVersion { get; set; }
    }
}
