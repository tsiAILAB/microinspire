using Newtonsoft.Json.Converters;

namespace Core
{
    public class DateTimeConverter : IsoDateTimeConverter
    {
        public DateTimeConverter()
        {
            DateTimeFormat = Util.SysDateTimeFormat;
        }
    }
}
