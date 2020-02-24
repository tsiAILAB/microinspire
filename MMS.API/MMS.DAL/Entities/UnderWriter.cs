using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("UnderWriter")]
	public class UnderWriter : EntityBase
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public int UnderWriterId { get; set; }
		[Required]
		public string Name { get; set; }

	}
}