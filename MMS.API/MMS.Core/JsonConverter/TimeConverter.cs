using Newtonsoft.Json.Converters;

namespace Core
{
    public class TimeConverter : IsoDateTimeConverter
    {
        public TimeConverter()
        {
            DateTimeFormat = Util.TimeFormat;
        }
    }
}
