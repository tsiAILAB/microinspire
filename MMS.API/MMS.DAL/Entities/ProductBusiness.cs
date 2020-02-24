using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("ProductBusiness")]
	public class ProductBusiness : Auditable
	{
		[Key]
		public int PLBId { get; set; }
		
		public int ProductId { get; set; }
		
		public int BusinessId { get; set; }
		
		public int? SeqNo { get; set; }
		
		public bool? IsActive { get; set; }

	}
}