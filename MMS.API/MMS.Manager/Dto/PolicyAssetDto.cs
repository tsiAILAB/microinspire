using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(PolicyAsset)), Serializable]
	public class PolicyAssetDto : Auditable
	{

		private int assetId;
		public int AssetId 
		{
			get
			{
				return assetId;
			}
			set
			{
				if (PropertyChanged(assetId, value))
					assetId = value;
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

		private string assetType;
		public string AssetType 
		{
			get
			{
				return assetType;
			}
			set
			{
				if (PropertyChanged(assetType, value))
					assetType = value;
			}
		}

		private decimal assetValue;
		public decimal AssetValue 
		{
			get
			{
				return assetValue;
			}
			set
			{
				if (PropertyChanged(assetValue, value))
					assetValue = value;
			}
		}

		private string assetDescription;
		public string AssetDescription 
		{
			get
			{
				return assetDescription;
			}
			set
			{
				if (PropertyChanged(assetDescription, value))
					assetDescription = value;
			}
		}

        private int assetCount;
        public int AssetCount
        {
            get
            {
                return assetCount;
            }
            set
            {
                if (PropertyChanged(assetCount, value))
                    assetCount = value;
            }
        }

        private string businessDescription;
		public string BusinessDescription 
		{
			get
			{
				return businessDescription;
			}
			set
			{
				if (PropertyChanged(businessDescription, value))
					businessDescription = value;
			}
		}

		private string address;
		public string Address 
		{
			get
			{
				return address;
			}
			set
			{
				if (PropertyChanged(address, value))
					address = value;
			}
		}

		private string location;
		public string Location 
		{
			get
			{
				return location;
			}
			set
			{
				if (PropertyChanged(location, value))
					location = value;
			}
		}

		private string postalCode;
		public string PostalCode 
		{
			get
			{
				return postalCode;
			}
			set
			{
				if (PropertyChanged(postalCode, value))
					postalCode = value;
			}
		}

		private string structureType;
		public string StructureType 
		{
			get
			{
				return structureType;
			}
			set
			{
				if (PropertyChanged(structureType, value))
					structureType = value;
			}
		}

	}
}