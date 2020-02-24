using AutoMapper;
using System;
using System.Reflection;

namespace MMS.Manager
{
    public static class AutoMapperConfigurationExtensions
    {
        public static void CreateAutoAttributeMaps(this IProfileExpression profile, Type type)
        {
            foreach (AutoMapAttributeBase customAttribute in type.GetCustomAttributes<AutoMapAttributeBase>())
                customAttribute.CreateMap(profile, type);
        }
    }
}
