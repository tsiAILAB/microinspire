using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(AssignedPartner)), Serializable]
	public class AssignedPartnerDto : AuditCreate
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

		private int partnerId;
		public int PartnerId 
		{
			get
			{
				return partnerId;
			}
			set
			{
				if (PropertyChanged(partnerId, value))
					partnerId = value;
			}
		}

    }
}