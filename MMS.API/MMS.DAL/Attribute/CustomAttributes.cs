using System;

namespace MMS.DAL
{
    /// <summary>
    /// Used to define auto-repository types for entities.
    /// This can be used for DbContext types.
    /// </summary>
    [AttributeUsage(AttributeTargets.Class)]
    public class RepositoryTypesAttribute : Attribute
    {
        public Type RepositoryInterface { get; private set; }

        public Type RepositoryImplementation { get; private set; }

        public RepositoryTypesAttribute(Type repositoryInterface, Type repositoryImplementation)
        {
            RepositoryInterface = repositoryInterface;            
            RepositoryImplementation = repositoryImplementation;            
        }
    }


    [AttributeUsage(AttributeTargets.Property)]
    public class LoggableAttribute : Attribute
    {        
    }
}
