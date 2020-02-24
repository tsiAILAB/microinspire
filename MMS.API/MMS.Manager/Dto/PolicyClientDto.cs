using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(PolicyClient)), Serializable]
	public class PolicyClientDto : EntityBase
    {

		private int pCId;
		public int PCId 
		{
			get
			{
				return pCId;
			}
			set
			{
				if (PropertyChanged(pCId, value))
					pCId = value;
			}
		}

		private int policyId;
		public int PolicyId 
		{
			get
			{
				return policyId;
			}
			set
			{
				if (PropertyChanged(policyId, value))
					policyId = value;
			}
		}

		private int clientId;
		public int ClientId 
		{
			get
			{
				return clientId;
			}
			set
			{
				if (PropertyChanged(clientId, value))
					clientId = value;
			}
		}
		
	}
}