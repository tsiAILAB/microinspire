using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("ProductConfig")]
	public class ProductConfig : Auditable
	{
		[Key]
		public int PCId { get; set; }
		
		public int ProductId { get; set; }
		
		public string ConfigType { get; set; }
		[Required]
		public string ConfigName { get; set; }
		
		public string ConfigValue { get; set; }
		
		public int? SeqNo { get; set; }
		
		public bool? IsActive { get; set; }

	}
}