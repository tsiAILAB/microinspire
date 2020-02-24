using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("Benefit")]
	public class Benefit : EntityBase
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public int BenefitId { get; set; }
		[Required]
		public string Name { get; set; }
		
		public int? SeqNo { get; set; }

	}
}