using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
	[AutoMap(typeof(ProductBusiness)), Serializable]
	public class ProductBusinessDto : Auditable
	{

		private int pLBId;
		public int PLBId 
		{
			get
			{
				return pLBId;
			}
			set
			{
				if (PropertyChanged(pLBId, value))
					pLBId = value;
			}
		}

		private int productId;
		public int ProductId 
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