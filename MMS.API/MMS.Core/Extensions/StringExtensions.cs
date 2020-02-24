using System;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace MMS.Core
{
    public static class StringExtensions
    {
        public static DateTime ToDate(this string input, bool throwException = false)
        {
            DateTime result;
            var valid = DateTime.TryParse(input, out result);
            if (valid) return result;
            if (throwException)
                throw new FormatException(string.Format("'{0}' cannot be converted as DateTime", input));
            return result;
        }

        public static DateTime ToDateTime(this string str, string dateFormat)
        {
            if (string.IsNullOrEmpty(str)) return DateTime.MinValue;
            if (str.Trim().Length <= 0) return DateTime.MinValue;
            try
            {
                var provider = CultureInfo.InvariantCulture;
                return DateTime.ParseExact(str.Trim(), dateFormat, provider);
            }
            catch
            {
                return DateTime.MinValue;
            }
        }

        public static short ToShort(this string input, bool throwException = false)
        {
            short result;
            var valid = short.TryParse(input, out result);
            if (valid) return result;
            if (throwException)
                throw new FormatException(string.Format("'{0}' cannot be converted as short", input));
            return result;
        }

        public static int ToInt(this string input, bool throwException = false)
        {
            int result;
            var valid = int.TryParse(input, out result);
            if (valid) return result;
            if (throwException)
                throw new FormatException(string.Format("'{0}' cannot be converted as int", input));
            return result;
        }

        public static long ToLong(this string input, bool throwException = false)
        {
            long result;
            var valid = long.TryParse(input, out result);
            if (valid) return result;
            if (throwException)
                throw new FormatException(string.Format("'{0}' cannot be converted as long", input));
            return result;
        }

        public static double ToDouble(this string input, bool throwException = false)
        {
            double result;
            var valid = double.TryParse(input, NumberStyles.AllowDecimalPoint, new NumberFormatInfo { NumberDecimalSeparator = "." }, out result);
            if (valid) return result;
            if (throwException)
                throw new FormatException(string.Format("'{0}' cannot be converted as double", input));
            return result;
        }

        public static decimal ToDecimal(this string input, bool throwException = false)
        {
            decimal result;
            var valid = decimal.TryParse(input, NumberStyles.AllowDecimalPoint, new NumberFormatInfo { NumberDecimalSeparator = "." }, out result);
            if (valid) return result;
            if (throwException)
                throw new FormatException(string.Format("'{0}' cannot be converted as decimal", input));
            return result;
        }

        public static bool ToBoolean(this string input, bool throwException = false)
        {
            bool result;
            var valid = bool.TryParse(input, out result);
            if (valid) return result;
            if (throwException)
                throw new FormatException(string.Format("'{0}' cannot be converted as boolean", input));
            return result;
        }


        public static string Reverse(this string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return string.Empty;
            var chars = input.ToCharArray();
            Array.Reverse(chars);
            return new string(chars);
        }

        public static bool IsNullOrEmpty(this string str)
        {
            return string.IsNullOrEmpty(str);
        }
        public static bool IsNotNullOrEmpty(this string str)
        {
            return !string.IsNullOrEmpty(str);
        }

        public static int SafeGetLength(this string valueOrNull)
        {
            return (valueOrNull ?? string.Empty).Length;
        }

        /// <summary>
        /// Matching all capital letters in the input and seperate them with spaces to form a sentence.
        /// If the input is an abbreviation text, no space will be added and returns the same input.
        /// </summary>
        /// <example>
        /// input : HelloWorld
        /// output : Hello World
        /// </example>
        /// <example>
        /// input : BBC
        /// output : BBC
        /// </example>
        /// <param name="input"></param>
        /// <returns></returns>
        public static string ToSentence(this string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return input;
            //return as is if the input is just an abbreviation
            if (Regex.Match(input, "[0-9A-Z]+$").Success)
                return input;
            //add a space before each capital letter, but not the first one.
            var result = Regex.Replace(input, "(\\B[A-Z])", " $1");
            return result;
        }

        public static string GetLast(this string input, int howMany)
        {
            if (string.IsNullOrWhiteSpace(input)) return string.Empty;
            var value = input.Trim();
            return howMany >= value.Length ? value : value.Substring(value.Length - howMany);
        }
        public static string GetFirst(this string input, int howMany)
        {
            if (string.IsNullOrWhiteSpace(input)) return string.Empty;
            var value = input.Trim();
            return howMany >= value.Length ? value : input.Substring(0, howMany);
        }
        public static bool IsEmail(this string input)
        {
            var match = Regex.Match(input, @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*", RegexOptions.IgnoreCase);
            return match.Success;
        }
        public static bool IsPhone(this string input)
        {
            var match = Regex.Match(input, @"^\+?(\d[\d-. ]+)?(\([\d-. ]+\))?[\d-. ]+\d$", RegexOptions.IgnoreCase);
            return match.Success;
        }
        public static bool IsNumber(this string input)
        {
            var match = Regex.Match(input, @"^[0-9]+$", RegexOptions.IgnoreCase);
            return match.Success;
        }

        public static int ExtractNumber(this string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return 0;

            var match = Regex.Match(input, "[0-9]+", RegexOptions.IgnoreCase);
            return match.Success ? match.Value.ToInt() : 0;
        }

        public static string ExtractEmail(this string input)
        {
            if (input == null || string.IsNullOrWhiteSpace(input)) return string.Empty;

            var match = Regex.Match(input, @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*", RegexOptions.IgnoreCase);
            return match.Success ? match.Value : string.Empty;
        }

        public static string ExtractQueryStringParamValue(this string queryString, string paramName)
        {
            if (string.IsNullOrWhiteSpace(queryString) || string.IsNullOrWhiteSpace(paramName)) return string.Empty;

            var query = queryString.Replace("?", "");
            if (!query.Contains("=")) return string.Empty;
            var queryValues = query.Split('&').Select(piQ => piQ.Split('=')).ToDictionary(piKey => piKey[0].ToLower().Trim(), piValue => piValue[1]);
            string result;
            var found = queryValues.TryGetValue(paramName.ToLower().Trim(), out result);
            return found ? result : string.Empty;

        }
        public static string PascelCase(this string input)
        {
            return input.Substring(0, 1).ToUpper() + input.Substring(1);
        }
        public static string CamelCase(this string input)
        {
            return input.Substring(0, 1).ToLower() + input.Substring(1);
        }
        public static string SeparateWords(this string input)
        {
            var sepWord = string.Empty;
            var i = -1;
            foreach (var ch in input)
            {
                i++;
                if (i != 0 && Char.ToUpper(ch) == ch)
                {
                    sepWord += ' ';
                }
                sepWord += ch;
            }
            return sepWord;
        }
        public static string Left(this string str, int length)
        {
            str = (str ?? string.Empty);
            return str.Substring(0, Math.Min(length, str.Length));
        }

        public static string Right(this string str, int length)
        {
            str = (str ?? string.Empty);
            return (str.Length >= length)
                ? str.Substring(str.Length - length, length)
                : str;
        }
    }
}
