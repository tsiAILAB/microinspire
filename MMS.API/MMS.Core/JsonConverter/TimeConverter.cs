using Newtonsoft.Json.Converters;

namespace MMS.Core
{
    public class TimeConverter : IsoDateTimeConverter
    {
        public TimeConverter()
        {
            DateTimeFormat = Util.TimeFormat;
        }
    }
}
