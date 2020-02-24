using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(Country)), Serializable]
	public class CountryDto : EntityBase
	{

		private int countryId;
		public int CountryId 
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

	}
}