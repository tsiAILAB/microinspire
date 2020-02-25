using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Core;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Threading.Tasks;

namespace MMS.API
{
    public class StartupBase
    {
        public StartupBase(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public virtual void ConfigureServices(IServiceCollection services)
        {
            services.AddMemoryCache();
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1)
            .AddJsonOptions(o =>
            {                
                o.SerializerSettings.ContractResolver = new DefaultContractResolver();
                o.SerializerSettings.DateTimeZoneHandling = DateTimeZoneHandling.Local;
                o.SerializerSettings.PreserveReferencesHandling = PreserveReferencesHandling.None;
                o.SerializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;
                o.SerializerSettings.Formatting = Formatting.Indented;
                //o.SerializerSettings.Converters.Add(new StringEnumConverter());
                o.SerializerSettings.DateFormatString = Util.SysDateFormat;
            });
            services.AddCors();
            services.AddHttpContextAccessor();
            var appSettingsSection = Configuration.GetSection("AppSettings");
            services.Configure<AppSettings>(appSettingsSection);

            services.AddSingleton<ILogger, FileLogger>();

            // configure jwt authentication
            var appSettings = appSettingsSection.Get<AppSettings>();
            var key = Encoding.ASCII.GetBytes(appSettings.Secret);
            services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(x =>
            {
                x.Events = new JwtBearerEvents
                {
                    OnTokenValidated = context =>
                    {
                        var ipAddress = context.Principal.FindFirst("IPAddress").Value;
                        if (context.Principal.Identity.Name.IsNullOrEmpty()
                            || ipAddress.IsNullOrEmpty()
                            || !AppContexts.IsValidUser(ipAddress))
                        {
                            // return unauthorized if user no longer exists
                            context.Fail("Unauthorized");
                        }

                        var newUser = new AppUser
                        {
                            LogedId = context.Principal.FindFirst("LogedId").Value.ToInt(),
                            UserId = context.Principal.FindFirst("UserId").Value.ToInt(),
                            Email = context.Principal.FindFirst("Email").Value,
                            UserName = context.Principal.Identity.Name,
                            UserType = context.Principal.FindFirst("UserType").Value,
                            UserAgent = AppContexts.GetUserAgent(),
                            LogInDateTime = context.Principal.FindFirst("LogInDateTime").Value.ToDate(),
                            IPAddress = ipAddress,
                            EntrySource = context.Principal.FindFirst("EntrySource").Value,
                            PartnerId = context.Principal.FindFirst("PartnerId").Value.ToInt(),
                            ProductId = context.Principal.FindFirst("ProductId").Value.ToInt()
                        };
                        AppContexts.SetUserInfo(newUser);
                        //context.HttpContext.User = newUser;
                        return Task.CompletedTask;
                    }
                };
                x.RequireHttpsMetadata = false;
                x.SaveToken = true;
                x.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = true,
                    ValidIssuer = "MicroInspire",
                    ValidateAudience = true,
                    ValidAudience = "MicroInspire"
                };
            });
            var culture = appSettings.Culture ?? "en-US";
            services.Configure<RequestLocalizationOptions>(
               opts =>
               {
                   var supportedCultures = new List<CultureInfo>
                   {
                        new CultureInfo(culture)
                   };

                   opts.DefaultRequestCulture = new RequestCulture(culture);
                   // Formatting numbers, dates, etc.
                   opts.SupportedCultures = supportedCultures;
                   // UI strings that we have localized.
                   opts.SupportedUICultures = supportedCultures;
               });
            SetServerDateFormat(culture);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app,
            IHostingEnvironment env)
        {
            var options = app.ApplicationServices.GetService<IOptions<RequestLocalizationOptions>>();
            app.UseRequestLocalization(options.Value);
            // global cors policy
            app.UseCors(x => x
                .AllowAnyOrigin()
                .AllowAnyMethod()
                .AllowAnyHeader()
                .AllowCredentials());

            app.UseAuthentication();
            AppContexts.Configure(app.ApplicationServices.GetRequiredService<IHttpContextAccessor>());
            ConfigureConnectionStrings();
            app.UseMiddleware(typeof(ErrorHandling));
            app.UseStaticFiles();
            app.UseMvc();
        }
        private void ConfigureConnectionStrings()
        {
            var connectionList = Configuration.GetSection("ConnectionStrings").Get<List<Connection>>();
            AppContexts.ConfigureConnectionStrings(connectionList);
        }

        private static void SetServerDateFormat(string culture)
        {
            var cultureInfo = new CultureInfo(culture);
            var dateTimeFormat = DateTimeFormatInfo.GetInstance(cultureInfo);
            if (dateTimeFormat == null) return;
            var format = dateTimeFormat.ShortDatePattern;
            var separator = dateTimeFormat.DateSeparator;
            var formatArray = format.Split(separator.ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            format = string.Empty;
            foreach (var str in formatArray)
            {
                switch (str)
                {
                    case "d":
                        format += "dd" + separator;
                        break;
                    case "M":
                        format += "MM" + separator;
                        break;
                    default:
                        format += str + separator;
                        break;
                }
            }
            format = format.Substring(0, format.Length - 1);
            Util.SysDateFormat = format;
            Util.SysDateTimeFormat = $"{Util.SysDateFormat} {Util.TimeFormat}";
        }
    }
}
