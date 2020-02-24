using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("PolicyAsset")]
	public class PolicyAsset : Auditable
	{
		[Key]
		public int AssetId { get; set; }
		
		public int PolicyId { get; set; }
		
		public string AssetType { get; set; }
		
		public decimal AssetValue { get; set; }
		
		public string AssetDescription { get; set; }

        public int AssetCount { get; set; }

        public string BusinessDescription { get; set; }
		
		public string Address { get; set; }
		
		public string Location { get; set; }
		
		public string PostalCode { get; set; }
		
		public string StructureType { get; set; }

	}
}