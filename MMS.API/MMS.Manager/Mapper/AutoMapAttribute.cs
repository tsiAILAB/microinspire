using AutoMapper;
using Core;
using System;
using System.Collections.Generic;

namespace MMS.Manager
{
    public class AutoMapAttribute : AutoMapAttributeBase
    {
        public AutoMapAttribute(params Type[] targetTypes)
          : base(targetTypes)
        {
        }

        public override void CreateMap(IProfileExpression profile, Type type)
        {
            if (((ICollection<Type>)TargetTypes).IsNullOrEmpty())
                return;
            foreach (Type targetType in TargetTypes)
            {
                profile.CreateMap(type, targetType).IgnoreReadOnly(type);
                profile.CreateMap(targetType, type).IgnoreReadOnly(targetType);
            }
        }
    }
}
