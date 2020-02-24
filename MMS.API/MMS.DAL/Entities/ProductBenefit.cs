using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("ProductBenefit")]
	public class ProductBenefit : Auditable
	{
		[Key]
		public int PBId { get; set; }
		
		public int ProductId { get; set; }
		
		public int BenefitId { get; set; }

        public string CoverageType { get; set; }

        public string DefaultAssetType { get; set; }

        public bool? DisableAssetType { get; set; }

        public int? SeqNo { get; set; }
		
		public bool? IsActive { get; set; }

	}
}