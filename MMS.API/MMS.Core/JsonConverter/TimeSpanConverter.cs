using Newtonsoft.Json;
using System;
using System.Globalization;

namespace Core
{
    public class TimeSpanConverter : JsonConverter
    {
        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            var dateTime = DateTime.Now.ToBD();
            if (reader.Value.GetType() == typeof(DateTime))
                dateTime = Convert.ToDateTime(reader.Value);
            else
                dateTime = DateTime.ParseExact((string)reader.Value, Util.TimeFormat, CultureInfo.InvariantCulture);
            return dateTime.TimeOfDay;
        }

        public override bool CanConvert(Type objectType)
        {
            return typeof(TimeSpan).Equals(objectType);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            serializer.Serialize(writer, DateTime.MinValue.Add((TimeSpan)value).ToString(Util.TimeFormat));
        }
    }
}
