using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("AssignedRole")]
	public class AssignedRole : AuditCreate
    {
        public int UserId { get; set; }
        public string Role { get; set; }

    }
}