using AutoMapper;
using System;
using System.Reflection;
using System.Linq;

namespace MMS.Manager
{
    public class AutoMapperProfile : Profile
    {        
        public AutoMapperProfile(Assembly assembly)
        {
            FindAndAutoMapTypes(this, assembly);            
        }

        private void FindAndAutoMapTypes(IProfileExpression profile, Assembly assembly)
        {
            var typeArray = assembly.GetTypes()
                  .Where(type => type.IsDefined(typeof(AutoMapAttribute)) 
                  || type.IsDefined(typeof(AutoMapFromAttribute)) 
                  || type.IsDefined(typeof(AutoMapToAttribute)));            
            
            foreach (Type type in typeArray)
            {
                profile.CreateAutoAttributeMaps(type);
            }
        }
    }
}
