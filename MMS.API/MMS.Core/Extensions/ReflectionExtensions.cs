using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Core
{
    /// <summary>Defines helper methods for reflection.</summary>
    public static class ReflectionExtensions
    {
        /// <summary>
        /// Checks whether <paramref name="givenType" /> implements/inherits <paramref name="genericType" />.
        /// </summary>
        /// <param name="givenType">Type to check</param>
        /// <param name="genericType">Generic type</param>
        public static bool IsAssignableToGenericType(Type givenType, Type genericType)
        {
            TypeInfo typeInfo = givenType.GetTypeInfo();
            if (typeInfo.IsGenericType && givenType.GetGenericTypeDefinition() == genericType)
                return true;
            foreach (Type type in givenType.GetInterfaces())
            {
                if (type.GetTypeInfo().IsGenericType && type.GetGenericTypeDefinition() == genericType)
                    return true;
            }
            if (typeInfo.BaseType.IsNull())
                return false;
            return IsAssignableToGenericType(typeInfo.BaseType, genericType);
        }

        /// <summary>
        /// Gets a list of attributes defined for a class member and it's declaring type including inherited attributes.
        /// </summary>
        /// <param name="inherit">Inherit attribute from base classes</param>
        /// <param name="memberInfo">MemberInfo</param>
        public static List<object> GetAttributesOfMemberAndDeclaringType(MemberInfo memberInfo, bool inherit = true)
        {
            var objectList = new List<object>();
            objectList.AddRange(memberInfo.GetCustomAttributes(inherit));
            if (memberInfo.DeclaringType.IsNotNull())
                objectList.AddRange(memberInfo.DeclaringType.GetTypeInfo().GetCustomAttributes(inherit));
            return objectList;
        }

        /// <summary>
        /// Gets a list of attributes defined for a class member and type including inherited attributes.
        /// </summary>
        /// <param name="memberInfo">MemberInfo</param>
        /// <param name="type">Type</param>
        /// <param name="inherit">Inherit attribute from base classes</param>
        public static List<object> GetAttributesOfMemberAndType(MemberInfo memberInfo, Type type, bool inherit = true)
        {
            var objectList = new List<object>();
            var customAttributes1 = memberInfo.GetCustomAttributes(inherit);
            objectList.AddRange(customAttributes1);
            var customAttributes2 = type.GetTypeInfo().GetCustomAttributes(inherit);
            objectList.AddRange(customAttributes2);
            return objectList;
        }

        /// <summary>
        /// Gets a list of attributes defined for a class member and it's declaring type including inherited attributes.
        /// </summary>
        /// <typeparam name="TAttribute">Type of the attribute</typeparam>
        /// <param name="memberInfo">MemberInfo</param>
        /// <param name="inherit">Inherit attribute from base classes</param>
        public static List<TAttribute> GetAttributesOfMemberAndDeclaringType<TAttribute>(MemberInfo memberInfo, bool inherit = true) where TAttribute : Attribute
        {
            var attributeList = new List<TAttribute>();
            if (memberInfo.IsDefined(typeof(TAttribute), inherit))
                attributeList.AddRange(memberInfo.GetCustomAttributes(typeof(TAttribute), inherit).Cast<TAttribute>());
            if (memberInfo.DeclaringType.IsNotNull() && memberInfo.DeclaringType.GetTypeInfo().IsDefined(typeof(TAttribute), inherit))
                attributeList.AddRange(memberInfo.DeclaringType.GetTypeInfo().GetCustomAttributes(typeof(TAttribute), inherit).Cast<TAttribute>());
            return attributeList;
        }

        /// <summary>
        /// Gets a list of attributes defined for a class member and type including inherited attributes.
        /// </summary>
        /// <typeparam name="TAttribute">Type of the attribute</typeparam>
        /// <param name="memberInfo">MemberInfo</param>
        /// <param name="type">Type</param>
        /// <param name="inherit">Inherit attribute from base classes</param>
        public static List<TAttribute> GetAttributesOfMemberAndType<TAttribute>(MemberInfo memberInfo, Type type, bool inherit = true) where TAttribute : Attribute
        {
            var attributeList = new List<TAttribute>();
            if (memberInfo.IsDefined(typeof(TAttribute), inherit))
                attributeList.AddRange(memberInfo.GetCustomAttributes(typeof(TAttribute), inherit).Cast<TAttribute>());
            if (type.GetTypeInfo().IsDefined(typeof(TAttribute), inherit))
                attributeList.AddRange(type.GetTypeInfo().GetCustomAttributes(typeof(TAttribute), inherit).Cast<TAttribute>());
            return attributeList;
        }

        /// <summary>
        /// Tries to gets an of attribute defined for a class member and it's declaring type including inherited attributes.
        /// Returns default value if it's not declared at all.
        /// </summary>
        /// <typeparam name="TAttribute">Type of the attribute</typeparam>
        /// <param name="memberInfo">MemberInfo</param>
        /// <param name="defaultValue">Default value (null as default)</param>
        /// <param name="inherit">Inherit attribute from base classes</param>
        public static TAttribute GetSingleAttributeOfMemberOrDeclaringTypeOrDefault<TAttribute>(MemberInfo memberInfo, TAttribute defaultValue = null, bool inherit = true) where TAttribute : class
        {
            TAttribute attribute1 = memberInfo.GetCustomAttributes(true).OfType<TAttribute>().FirstOrDefault();
            if (attribute1.IsNotNull())
                return attribute1;
            Type declaringType = memberInfo.DeclaringType;
            TAttribute attribute2 = (object)declaringType != null ? declaringType.GetTypeInfo().GetCustomAttributes(true).OfType<TAttribute>().FirstOrDefault() : default(TAttribute);
            if (attribute2.IsNotNull())
                return attribute2;
            return defaultValue;
        }

        /// <summary>
        /// Tries to gets an of attribute defined for a class member and it's declaring type including inherited attributes.
        /// Returns default value if it's not declared at all.
        /// </summary>
        /// <typeparam name="TAttribute">Type of the attribute</typeparam>
        /// <param name="memberInfo">MemberInfo</param>
        /// <param name="defaultValue">Default value (null as default)</param>
        /// <param name="inherit">Inherit attribute from base classes</param>
        public static TAttribute GetSingleAttributeOrDefault<TAttribute>(MemberInfo memberInfo, TAttribute defaultValue = null, bool inherit = true) where TAttribute : Attribute
        {
            if (memberInfo.IsDefined(typeof(TAttribute), inherit))
                return memberInfo.GetCustomAttributes(typeof(TAttribute), inherit).Cast<TAttribute>().First();
            return defaultValue;
        }

        /// <summary>
        /// Gets value of a property by it's full path from given object
        /// </summary>
        /// <param name="obj">Object to get value from</param>
        /// <param name="objectType">Type of given object</param>
        /// <param name="propertyPath">Full path of property</param>
        /// <returns></returns>
        internal static object GetValueByPath(object obj, Type objectType, string propertyPath)
        {
            object obj1 = obj;
            Type type = objectType;
            string fullName = type.FullName;
            string str1 = propertyPath;
            if (str1.StartsWith(fullName))
                str1 = str1.Replace(fullName + ".", "");
            string str2 = str1;
            char[] chArray = new char[1] { '.' };
            foreach (string name in str2.Split(chArray))
            {
                PropertyInfo property = type.GetProperty(name);
                object obj2 = obj1;
                // ISSUE: variable of the null type
                object local = null;
                obj1 = property.GetValue(obj2, (object[])local);
                type = property.PropertyType;
            }
            return obj1;
        }

        /// <summary>
        /// Sets value of a property by it's full path on given object
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="objectType"></param>
        /// <param name="propertyPath"></param>
        /// <param name="value"></param>
        internal static void SetValueByPath(object obj, Type objectType, string propertyPath, object value)
        {
            Type type = objectType;
            string fullName = type.FullName;
            string str = propertyPath;
            if (str.StartsWith(fullName))
                str = str.Replace(fullName + ".", "");
            string[] strArray = str.Split('.');
            if (strArray.Length == 1)
            {
                objectType.GetProperty(((IEnumerable<string>)strArray).First()).SetValue(obj, value);
            }
            else
            {
                for (int index = 0; index < strArray.Length - 1; ++index)
                {
                    PropertyInfo property = type.GetProperty(strArray[index]);
                    object obj1 = obj;
                    // ISSUE: variable of the null type
                    object local = null;
                    obj = property.GetValue(obj1, (object[])local);
                    type = property.PropertyType;
                }
                type.GetProperty(((IEnumerable<string>)strArray).Last()).SetValue(obj, value);
            }
        }
    }
}
