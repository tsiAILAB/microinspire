using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(AssignedRole)), Serializable]
	public class AssignedRoleDto : AuditCreate
    {

		private int userId;
		public int UserId 
		{
			get
			{
				return userId;
			}
			set
			{
				if (PropertyChanged(userId, value))
					userId = value;
			}
		}

		private string role;
		public string Role 
		{
			get
			{
				return role;
			}
			set
			{
				if (PropertyChanged(role, value))
					role = value;
			}
		}

    }
}