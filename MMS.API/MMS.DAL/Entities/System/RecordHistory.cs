using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("RecordHistory")]
	public class RecordHistory : AuditCreate
	{
		[Key]
		public long HistoryId { get; set; }
		[Required]
		public string HistoryType { get; set; }
		
		public int KeyValue { get; set; }
		
		public string Description { get; set; }

	}
}