using MMS.Manager;
using System.Collections.Generic;

namespace MMS.API
{
    public class UserPrivilege
    {
        public int UserId { get; set; }
        public List<AssignedRoleDto> Roles { get; set; }
        public List<AssignedPartnerDto> Partners { get; set; }
    }
}
