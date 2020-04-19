using Newtonsoft.Json.Converters;

namespace Core
{
    public class DateConverter : IsoDateTimeConverter
    {
        public DateConverter()
        {
            DateTimeFormat = Util.SysDateFormat;
        }
    }
}
