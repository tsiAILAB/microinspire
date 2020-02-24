using MMS.Core;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace MMS.DAL
{
    public static class DbRegisterHelper
    {
        public static void RegisterForDbContext(Type contextType, IServiceCollection services)
        {
            RepositoryTypesAttribute repositoryTypesAttribute = contextType.GetSingleAttributeOrNull<RepositoryTypesAttribute>(true) ?? RepositoryTypes.Default;
            foreach (EntityTypeInfo entityTypeInfo in GetDbSetProperties(contextType))
            {
                Type type1 = repositoryTypesAttribute.RepositoryInterface.MakeGenericType(entityTypeInfo.EntityType);
                if (!services.Any(x => x.ServiceType == type1))
                {
                    Type type2;
                    if (repositoryTypesAttribute.RepositoryImplementation.GetGenericArguments().Length != 1)
                        type2 = repositoryTypesAttribute.RepositoryImplementation.MakeGenericType(entityTypeInfo.DeclaringType, entityTypeInfo.EntityType);
                    else
                        type2 = repositoryTypesAttribute.RepositoryImplementation.MakeGenericType(entityTypeInfo.EntityType);
                    services.AddTransient(type1, type2);
                }
            }
        }
        private static List<EntityTypeInfo> GetDbSetProperties(Type context)
        {
            var dbSetProperties = new List<PropertyInfo>();
            var properties = context.GetProperties();
            foreach (var property in properties)
            {
                var setType = property.PropertyType;
                var isDbSet = setType.IsGenericType && (typeof(DbSet<>).IsAssignableFrom(setType.GetGenericTypeDefinition()) || setType.GetInterface(typeof(DbSet<>).FullName) != null);

                if (isDbSet) dbSetProperties.Add(property);
            }
            return dbSetProperties.Select(property => new EntityTypeInfo(property.PropertyType.GenericTypeArguments[0], property.DeclaringType)).ToList();
        }
    }
}
