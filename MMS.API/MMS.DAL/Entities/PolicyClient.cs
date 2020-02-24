using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("PolicyClient")]
	public class PolicyClient : EntityBase
    {
		[Key]
		public int PCId { get; set; }
		
		public int PolicyId { get; set; }
		
		public int ClientId { get; set; }

	}
}