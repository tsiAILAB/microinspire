using System;
using System.Collections.Generic;
using System.Data;

namespace Core
{
    public static class ExtensionMethods
    {
        public static bool Compare<T>(T x, T y)
        {
            return EqualityComparer<T>.Default.Equals(x, y);
        }
        public static bool NotEquals<T>(this T val, T compVal)
        {
            return !Compare(val, compVal);
        }
        public static bool IsZero(this long val)
        {
            return val.Equals(0);
        }
        public static bool IsNotZero(this long val)
        {
            return !val.Equals(0);
        }
        public static bool IsZero(this decimal val)
        {
            return val.Equals(decimal.Zero);
        }
        public static bool IsNotZero(this decimal val)
        {
            return !val.Equals(decimal.Zero);
        }
        public static bool IsZero(this double val)
        {
            return val.Equals(0);
        }
        public static bool IsNotZero(this double val)
        {
            return !val.Equals(0);
        }
        public static bool IsZero(this int val)
        {
            return val.Equals(0);
        }
        public static bool IsNotZero(this int val)
        {
            return !val.Equals(0);
        }
        public static bool IsZero(this short val)
        {
            return val.Equals(0);
        }
        public static bool IsNotZero(this short val)
        {
            return !val.Equals(0);
        }
        public static bool GreaterThen(this long value, long val)
        {
            return value > val;
        }
        public static bool GreaterThen(this int value, int val)
        {
            return value > val;
        }
        public static bool GreaterThen(this short value, short val)
        {
            return value > val;
        }
        public static bool LessThen(this long value, long val)
        {
            return value < val;
        }
        public static bool LessThen(this int value, int val)
        {
            return value < val;
        }
        public static bool LessThen(this short value, short val)
        {
            return value < val;
        }
        public static bool IsTrue(this bool val)
        {
            return val;
        }
        public static bool IsFalse(this bool val)
        {
            return !val;
        }
        public static bool IsNull(this object obj)
        {
            return obj == null;
        }
        public static bool IsNotNull(this object obj)
        {
            return obj != null;
        }
        public static bool IsNullOrDbNull(this object obj)
        {
            return obj == null || obj == DBNull.Value;
        }
        public static bool IsMinValue(this DateTime obj)
        {
            return obj == DateTime.MinValue;
        }
        public static bool IsNotMinValue(this DateTime obj)
        {
            return obj != DateTime.MinValue;
        }
        public static bool IsNullOrMinValue(this DateTime? obj)
        {
            return obj == null || obj == DateTime.MinValue;
        }

        public static object Value(this object value)
        {
            return value ?? DBNull.Value;
        }

        public static object Value(this DateTime dateTime, string format = Util.DateFormat)
        {
            if (dateTime.Equals(DateTime.MinValue))
                return DBNull.Value;
            return dateTime.ToString(format);
        }

        public static object Value(this DateTime? dateTime, string format = Util.DateFormat)
        {
            if (dateTime.IsNull() || dateTime.Equals(DateTime.MinValue))
                return DBNull.Value;
            return Convert.ToDateTime(dateTime).ToString(format);
        }

        public static string StringValue(this DateTime dateTime)
        {
            return dateTime.Equals(DateTime.MinValue) ? string.Empty : dateTime.ToString(Util.DateFormat);
        }

        public static string StringValue(this DateTime? dateTime)
        {
            return dateTime.IsNull() ? string.Empty : Convert.ToDateTime(dateTime).ToString(Util.DateFormat);
        }

        public static DateTime ToBD(this DateTime dateTime)
        {            
            var bdZone = TimeZoneInfo.FindSystemTimeZoneById("Bangladesh Standard Time");
            return TimeZoneInfo.ConvertTime(dateTime, bdZone);
        }

        public static int GetAge(this DateTime dateOfBirth)
        {
            var today = DateTime.Today;
            var a = (today.Year * 100 + today.Month) * 100 + today.Day;
            var b = (dateOfBirth.Year * 100 + dateOfBirth.Month) * 100 + dateOfBirth.Day;
            return (a - b) / 10000;
        }

        public static void CloseReader(this IDataReader reader)
        {
            if (reader.IsNotNull() && !reader.IsClosed)
                reader.Close();
        }

        public static Exception GetOriginalException(this Exception ex)
        {
            if (ex.InnerException == null) return ex;

            return ex.InnerException.GetOriginalException();
        }

        public static void Sort<T, TU>(this List<T> list, Func<T, TU> expression, IComparer<TU> comparer) where TU : IComparable<TU>
        {
            list.Sort((x, y) => comparer.Compare(expression.Invoke(x), expression.Invoke(y)));
        }
    }
}
