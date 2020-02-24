using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(Partner)), Serializable]
	public class PartnerDto : Auditable
	{

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

		private string partnerCode;
		public string PartnerCode 
		{
			get
			{
				return partnerCode;
			}
			set
			{
				if (PropertyChanged(partnerCode, value))
					partnerCode = value;
			}
		}

		private string name;
		public string Name 
		{
			get
			{
				return name;
			}
			set
			{
				if (PropertyChanged(name, value))
					name = value;
			}
		}

		private int? countryId;
		public int? CountryId 
		{
			get
			{
				return countryId;
			}
			set
			{
				if (PropertyChanged(countryId, value))
					countryId = value;
			}
		}

		private int? seqNo;
		public int? SeqNo 
		{
			get
			{
				return seqNo;
			}
			set
			{
				if (PropertyChanged(seqNo, value))
					seqNo = value;
			}
		}

		private bool? isActive;
		public bool? IsActive 
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

	}
}