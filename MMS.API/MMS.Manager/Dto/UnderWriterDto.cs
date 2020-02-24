using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
	[AutoMap(typeof(UnderWriter)), Serializable]
	public class UnderWriterDto : EntityBase
	{

		private int underWriterId;
		public int UnderWriterId 
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