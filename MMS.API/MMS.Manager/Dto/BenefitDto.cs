using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(Benefit)), Serializable]
	public class BenefitDto : EntityBase
	{

		private int benefitId;
		public int BenefitId 
		{
			get
			{
				return benefitId;
			}
			set
			{
				if (PropertyChanged(benefitId, value))
					benefitId = value;
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