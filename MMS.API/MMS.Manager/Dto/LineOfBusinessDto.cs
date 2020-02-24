using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
	[AutoMap(typeof(LineOfBusiness)), Serializable]
	public class LineOfBusinessDto : EntityBase
	{

		private int businessId;
		public int BusinessId 
		{
			get
			{
				return businessId;
			}
			set
			{
				if (PropertyChanged(businessId, value))
					businessId = value;
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

		private int? underWriterId;
		public int? UnderWriterId 
		{
			get
			{
				return underWriterId;
			}
			set
			{
				if (PropertyChanged(underWriterId, value))
					underWriterId = value;
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

	}
}