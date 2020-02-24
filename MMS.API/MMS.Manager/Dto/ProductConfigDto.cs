using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(ProductConfig)), Serializable]
	public class ProductConfigDto : Auditable
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

		private string configType;
		public string ConfigType 
		{
			get
			{
				return configType;
			}
			set
			{
				if (PropertyChanged(configType, value))
					configType = value;
			}
		}

		private string configName;
		public string ConfigName 
		{
			get
			{
				return configName;
			}
			set
			{
				if (PropertyChanged(configName, value))
					configName = value;
			}
		}

		private string configValue;
		public string ConfigValue 
		{
			get
			{
				return configValue;
			}
			set
			{
				if (PropertyChanged(configValue, value))
					configValue = value;
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