using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(AgentUser)), Serializable]
	public class AgentUsersDto : Auditable
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

		private string email;
		public string Email 
		{
			get
			{
				return email;
			}
			set
			{
				if (PropertyChanged(email, value))
					email = value;
			}
		}

		private string userName;
		public string UserName 
		{
			get
			{
				return userName;
			}
			set
			{
				if (PropertyChanged(userName, value))
					userName = value;
			}
		}

		private string token;
		public string Token 
		{
			get
			{
				return token;
			}
			set
			{
				if (PropertyChanged(token, value))
					token = value;
			}
		}

		private int? partnerId;
		public int? PartnerId 
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

		private int? productId;
		public int? ProductId 
		{
			get
			{
				return productId;
			}
			set
			{
				if (PropertyChanged(productId, value))
					productId = value;
			}
		}

		private bool isActive;
		public bool IsActive 
		{
			get
			{
				return isActive;
			}
			set
			{
				if (PropertyChanged(isActive, value))
					isActive = value;
			}
		}

        public string Key { get; set; }

    }
}