using Newtonsoft.Json.Converters;

namespace MMS.Core
{
    public class SystemDateTimeConverter : IsoDateTimeConverter
    {
        public SystemDateTimeConverter()
        {
            DateTimeFormat = Util.DateTimeFormat;
        }

    }
}
