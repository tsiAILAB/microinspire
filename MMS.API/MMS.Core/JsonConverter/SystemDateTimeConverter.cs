using Newtonsoft.Json.Converters;

namespace Core
{
    public class SystemDateTimeConverter : IsoDateTimeConverter
    {
        public SystemDateTimeConverter()
        {
            DateTimeFormat = Util.DateTimeFormat;
        }

    }
}
