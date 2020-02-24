using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("ClaimDocument")]
	public class ClaimDocument : Auditable
	{
		[Key]
		public int DocumentId { get; set; }
		
		public int ClaimId { get; set; }
		[Required]
		public string DocumentType { get; set; }
        [Required]
        public string FilePath { get; set; }
		[Required]
		public string FileName { get; set; }
        [Required]
        public string OrgFileName { get; set; }

        public string Comments { get; set; }

	}
}