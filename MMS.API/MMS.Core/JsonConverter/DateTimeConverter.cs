using Newtonsoft.Json.Converters;

namespace MMS.Core
{
    public class DateTimeConverter : IsoDateTimeConverter
    {
        public DateTimeConverter()
        {
            DateTimeFormat = Util.SysDateTimeFormat;
        }
    }
}
