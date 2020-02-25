using Core;
using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(RecordHistory)), Serializable]
	public class RecordHistoryDto : AuditCreate
	{

		private long historyId;
		[JsonConverter(typeof(LongToStringConverter))]
		public long HistoryId 
		{
			get
			{
				return historyId;
			}
			set
			{
				if (PropertyChanged(historyId, value))
					historyId = value;
			}
		}

		private string historyType;
		public string HistoryType 
		{
			get
			{
				return historyType;
			}
			set
			{
				if (PropertyChanged(historyType, value))
					historyType = value;
			}
		}

		private int keyValue;
		public int KeyValue 
		{
			get
			{
				return keyValue;
			}
			set
			{
				if (PropertyChanged(keyValue, value))
					keyValue = value;
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

	}
}