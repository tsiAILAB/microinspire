using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("LineOfBusiness")]
	public class LineOfBusiness : EntityBase
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public int BusinessId { get; set; }
		[Required]
		public string Name { get; set; }
		
		public int? UnderWriterId { get; set; }
		
		public int? SeqNo { get; set; }

	}
}