using Newtonsoft.Json;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("AuditLog")]
	public class AuditLog: AuditCreate
    {
		[Key]
		public long AuditId { get; set; }
		[Required]
		public string TableName { get; set; }
		public DateTime AuditAt { get; set; }
		[Required]
		public string KeyValues { get; set; }
		public string OldValues { get; set; }
		public string NewValues { get; set; }
		[Required]
		public string RowState { get; set; }
        public string UserAgent { get; set; }        

    }
}