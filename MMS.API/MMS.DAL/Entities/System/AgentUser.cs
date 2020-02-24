using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("AgentUsers")]
	public class AgentUser : Auditable
	{
		[Key]
		public int UserId { get; set; }
		[Required]
		public string Email { get; set; }
		[Required]
		public string UserName { get; set; }
		
		public string Token { get; set; }
		
		public int? PartnerId { get; set; }
		
		public int? ProductId { get; set; }
		
		public bool IsActive { get; set; }

	}
}