using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(ProductBenefit)), Serializable]
	public class ProductBenefitDto : Auditable
	{

		private int pBId;
		public int PBId 
		{
			get
			{
				return pBId;
			}
			set
			{
				if (PropertyChanged(pBId, value))
					pBId = value;
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

        private string coverageType;
        public string CoverageType
        {
            get
            {
                return coverageType;
            }
            set
            {
                if (PropertyChanged(coverageType, value))
                    coverageType = value;
            }
        }

        private string defaultAssetType;
        public string DefaultAssetType
        {
            get
            {
                return defaultAssetType;
            }
            set
            {
                if (PropertyChanged(defaultAssetType, value))
                    defaultAssetType = value;
            }
        }

        private bool? disableAssetType;
        public bool? DisableAssetType
        {
            get
            {
                return disableAssetType;
            }
            set
            {
                if (PropertyChanged(disableAssetType, value))
                    disableAssetType = value;
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