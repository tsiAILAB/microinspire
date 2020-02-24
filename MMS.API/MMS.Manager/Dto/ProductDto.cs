using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(Product)), Serializable]
	public class ProductDto : Auditable
	{

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

		private string productCode;
		public string ProductCode 
		{
			get
			{
				return productCode;
			}
			set
			{
				if (PropertyChanged(productCode, value))
					productCode = value;
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

        private string externalId;
        public string ExternalId
        {
            get
            {
                return externalId;
            }
            set
            {
                if (PropertyChanged(externalId, value))
                    externalId = value;
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