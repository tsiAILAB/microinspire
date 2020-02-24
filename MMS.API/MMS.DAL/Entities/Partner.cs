using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("Partner")]
	public class Partner : Auditable
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public int PartnerId { get; set; }
		[Required]
		public string PartnerCode { get; set; }
		[Required]
		public string Name { get; set; }
		
		public int? CountryId { get; set; }
		
		public int? SeqNo { get; set; }
		
		public bool? IsActive { get; set; }

	}
}