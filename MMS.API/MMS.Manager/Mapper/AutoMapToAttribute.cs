using AutoMapper;
using MMS.Core;
using System;
using System.Collections.Generic;

namespace MMS.Manager
{
    public class AutoMapToAttribute : AutoMapAttributeBase
    {
        public MemberList MemberList { get; set; } = (MemberList)1;

        public AutoMapToAttribute(params Type[] targetTypes)
          : base(targetTypes)
        {
        }

        public AutoMapToAttribute(MemberList memberList, params Type[] targetTypes)
          : this(targetTypes)
        {
            MemberList = memberList;
        }

        public override void CreateMap(IProfileExpression profile, Type type)
        {
            if (((ICollection<Type>)TargetTypes).IsNullOrEmpty())
                return;
            foreach (Type targetType in TargetTypes)
                profile.CreateMap(type, targetType, MemberList).IgnoreReadOnly(type);
        }
    }
}
