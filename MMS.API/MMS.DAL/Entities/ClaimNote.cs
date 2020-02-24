using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("ClaimNote")]
	public class ClaimNote : Auditable
	{
		[Key]
		public int NoteId { get; set; }
		
		public int ClaimId { get; set; }
		[Required]
		public string Note { get; set; }

	}
}