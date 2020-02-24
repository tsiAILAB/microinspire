using Microsoft.Extensions.DependencyInjection;
using MMS.Core;

namespace MMS.DAL
{
    public static class Installer
    {
        public static void ConfigureServices(IServiceCollection services)
        {   
            services.AddDbContext<MMSDbContext>(options =>
            {
                options.UseDatabase(ConnectionName.MMS);
            });
            DbRegisterHelper.RegisterForDbContext(typeof(MMSDbContext), services);

            services.AddTransient(typeof(IModelAdapter), typeof(ModelAdapter));
        }
    }
}

