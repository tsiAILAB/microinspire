using MMS.Manager;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace MMS.API
{
    public class Startup : StartupBase
    {
        public Startup(IConfiguration configuration) : base(configuration)
        {

        }
        public override void ConfigureServices(IServiceCollection services)
        {
            base.ConfigureServices(services);
            Installer.ConfigureServices(services);
        }
    }
}
