using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(Configuration)), Serializable]
	public class ConfigurationDto : Auditable
	{

		private int configId;
		public int ConfigId 
		{
			get
			{
				return configId;
			}
			set
			{
				if (PropertyChanged(configId, value))
					configId = value;
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

		private string description;
		public string Description 
		{
			get
			{
				return description;
			}
			set
			{
				if (PropertyChanged(description, value))
					description = value;
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

		private bool? isSystemConfig;
		public bool? IsSystemConfig 
		{
			get
			{
				return isSystemConfig;
			}
			set
			{
				if (PropertyChanged(isSystemConfig, value))
					isSystemConfig = value;
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