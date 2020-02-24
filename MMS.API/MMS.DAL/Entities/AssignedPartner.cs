using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("AssignedPartner")]
	public class AssignedPartner : AuditCreate
    {
        public int UserId { get; set; }
        public int PartnerId { get; set; }

    }
}