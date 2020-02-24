using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("Product")]
	public class Product : Auditable
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public int ProductId { get; set; }
		
		public int PartnerId { get; set; }
		[Required]
		public string ProductCode { get; set; }
		[Required]
		public string Name { get; set; }
        public string ExternalId { get; set; }

        public int? SeqNo { get; set; }
		
		public bool? IsActive { get; set; }

	}
}