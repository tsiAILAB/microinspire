using System;
using System.Reflection;

namespace Core
{
    /// <summary>
    /// Extensions to <see cref="T:System.Reflection.MemberInfo" />.
    /// </summary>
    public static class MemberExtensions
    {
        /// <summary>Gets a single attribute for a member.</summary>
        /// <typeparam name="TAttribute">Type of the attribute</typeparam>
        /// <param name="memberInfo">The member that will be checked for the attribute</param>
        /// <param name="inherit">Include inherited attributes</param>
        /// <returns>Returns the attribute object if found. Returns null if not found.</returns>
        public static TAttribute GetSingleAttributeOrNull<TAttribute>(this MemberInfo memberInfo, bool inherit = true) where TAttribute : Attribute
        {
            if (memberInfo.IsNull())
                throw new ArgumentNullException("memberInfo");
            object[] customAttributes = memberInfo.GetCustomAttributes(typeof(TAttribute), inherit);
            if (customAttributes.Length.IsNotZero())
                return (TAttribute)customAttributes[0];
            return default(TAttribute);
        }

        public static TAttribute GetSingleAttributeOfTypeOrBaseTypesOrNull<TAttribute>(this Type type, bool inherit = true) where TAttribute : Attribute
        {
            TAttribute singleAttributeOrNull = type.GetSingleAttributeOrNull<TAttribute>(true);
            if (singleAttributeOrNull.IsNotNull())
                return singleAttributeOrNull;
            if (type.BaseType.IsNull())
                return default(TAttribute);
            return type.BaseType.GetSingleAttributeOfTypeOrBaseTypesOrNull<TAttribute>(inherit);
        }
    }
}
