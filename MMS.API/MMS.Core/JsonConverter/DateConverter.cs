using Newtonsoft.Json.Converters;

namespace MMS.Core
{
    public class DateConverter : IsoDateTimeConverter
    {
        public DateConverter()
        {
            DateTimeFormat = Util.SysDateFormat;
        }
    }
}
