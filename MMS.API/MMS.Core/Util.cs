using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace Core
{
    public static class Util
    {
        public const string DateFormat = "yyyy-MMM-dd";
        public const string TimeFormat = "hh:mm tt";
        public const string DateTimeFormat = "yyyy-MM-dd hh:mm:ss.fff";
        public static string SysDateFormat = "MM/dd/yyyy";
        public static string SysDateTimeFormat = "MM/dd/yyyy hh:mm tt";
        public static int GetEnumValue(Type enumType, string value)
        {
            switch (value)
            {
                case "Integer":
                    value = "Int32";
                    break;
                case "Float":
                    value = "double";
                    break;
            }
            var i = (int)Enum.Parse(enumType, value);
            return i;
        }

        public static List<KeyValuePair<int, string>> GetAllMonths()
        {
            var monthList = new List<KeyValuePair<int, string>>();
            for (var i = 1; i <= 12; i++)
            {
                if (DateTimeFormatInfo.CurrentInfo != null)
                    monthList.Add(new KeyValuePair<int, string>(i, DateTimeFormatInfo.CurrentInfo.GetMonthName(i)));
            }
            return monthList;
        }

        public static string BuildXmlString(string xmlRootName, IEnumerable<string> values)
        {
            var xmlString = new StringBuilder();

            xmlString.AppendFormat("<{0}>", xmlRootName);
            foreach (var str in values)
            {
                xmlString.AppendFormat("<value>{0}</value>", str);
            }
            xmlString.AppendFormat("</{0}>", xmlRootName);

            return xmlString.ToString();
        }

        //Call Util.ListFrom<TypeOfEnum>()
        public static IList<dynamic> ListFrom<T>()
        {
            var list = new List<dynamic>();
            var enumType = typeof(T);
            foreach (var o in Enum.GetValues(enumType))
            {
                list.Add(new
                {
                    Name = Enum.GetName(enumType, o),
                    Value = o
                });
            }
            return list;
        }

        public static string SerializeObject(object value)
        {
            var settings = new JsonSerializerSettings
            {
                ContractResolver = new DefaultContractResolver(),
                DateTimeZoneHandling = DateTimeZoneHandling.Local,
                PreserveReferencesHandling = PreserveReferencesHandling.None,
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore,
                DateFormatString = SysDateFormat,
            };

            return JsonConvert.SerializeObject(value, settings);

        }

    }
}
