namespace MMS.DAL
{
    internal static class RepositoryTypes
    {
        public static RepositoryTypesAttribute Default { get; private set; }

        static RepositoryTypes()
        {
            Default = new RepositoryTypesAttribute(typeof(IRepository<>), typeof(Repository<,>));
        }
    }
}
