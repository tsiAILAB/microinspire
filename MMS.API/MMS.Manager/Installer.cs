using AutoMapper;
using MMS.Core;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Linq;
using System.Reflection;

namespace MMS.Manager
{
    public static class Installer
    {
        public static void ConfigureServices(IServiceCollection services)
        {
            DAL.Installer.ConfigureServices(services);
            var types = Assembly.GetExecutingAssembly().GetTypes()
                .Where(type => type.BaseType == typeof(ManagerBase));

            foreach (Type type in types)
            {
                var interfaces = type.GetInterfaces();
                if (interfaces.Length.IsNotZero())
                {
                    services.AddTransient(interfaces[0], type);
                }
            }

            services.AddTransient(typeof(IComboManager), typeof(ComboManager));
            services.AddTransient(typeof(IReportManager), typeof(ReportManager));            

            Mapper.Initialize(cfg =>
            {
                var profile = new AutoMapperProfile(Assembly.GetExecutingAssembly());
                cfg.AddProfile(profile);
            });
        }
    }
}

