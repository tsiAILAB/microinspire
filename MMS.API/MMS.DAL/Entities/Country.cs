using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("Country")]
	public class Country : EntityBase
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public int CountryId { get; set; }
		[Required]
		public string Name { get; set; }

	}
}