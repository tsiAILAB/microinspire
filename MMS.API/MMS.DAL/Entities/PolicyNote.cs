using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("PolicyNote")]
	public class PolicyNote : Auditable
	{
		[Key]
		public int NoteId { get; set; }
		
		public int PolicyId { get; set; }
		[Required]
		public string Note { get; set; }

	}
}