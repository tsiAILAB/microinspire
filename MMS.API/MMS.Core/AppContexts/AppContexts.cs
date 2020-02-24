using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;

namespace MMS.Core
{
    public static class AppContexts
    {
        private static IHttpContextAccessor httpContextAccessor;
        private static List<Connection> connectionList { get; set; }

        public static void Configure(IHttpContextAccessor httpContextAccessor)
        {
            AppContexts.httpContextAccessor = httpContextAccessor;
        }
        public static void ConfigureConnectionStrings(List<Connection> connections)
        {
            connectionList = new List<Connection>();
            var server = string.Empty;
            var database = string.Empty;
            foreach (var connection in connections)
            {
                var connectionString = connection.ConnectionString;
                var serverInfo = connectionString.Split(";".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                foreach (var info in serverInfo)
                {
                    if (info.Trim().ToLower().StartsWith("data source") || info.Trim().ToLower().StartsWith("server"))
                    {
                        connection.Server = info.Split('=')[1].Trim();
                    }
                    else if (info.Trim().ToLower().StartsWith("initial catalog") || info.Trim().ToLower().StartsWith("database"))
                    {
                        connection.Database = info.Split('=')[1].Trim();
                    }
                }
                connectionList.Add(connection);
            }
        }
        public static Connection GetConnection(string conName)
        {
            return connectionList.Find(con => con.Name.Equals(conName));
        }

        public static string GetDatabaseName(string conName)
        {
            var connection = connectionList.Find(con => con.Name.Equals(conName));
            return connection.IsNull() ? string.Empty : connection.Database;
        }
        public static string GetConnectionString(string conName)
        {
            var connection = connectionList.Find(con => con.Name.Equals(conName));
            return connection.IsNull() ? string.Empty : connection.ConnectionString;
        }
        public static HttpContext Current => httpContextAccessor.HttpContext;
        public static AppUser User
        {
            get
            {
                var user = new AppUser { UserId = -1, Email = "System@System.com", UserName = "System", UserType = "System", UserAgent = "Windows", IPAddress = GetIPAddress(), EntrySource = "Portal", PartnerId = -1, ProductId = -1 };
                if (Current.Items["ActiveUser"].IsNotNull())
                    user = Current.Items["ActiveUser"] as AppUser;
                return user;
            }
        }
        public static void Resolve<T>()
        {
            Current.RequestServices.GetService(typeof(T));
        }
        public static void Resolve(Type type)
        {
            Current.RequestServices.GetService(type);
        }
        public static T GetInstance<T>()
        {
            return (T)Current.RequestServices.GetService(typeof(T));
        }
        public static object GetInstance(Type type)
        {
            return Current.RequestServices.GetService(type);
        }
        public static void SetActiveDbContext<T>(T context)
        {
            var list = new List<T>();
            if (Current.Items["ActiveDbContext"].IsNotNull())
                list = Current.Items["ActiveDbContext"] as List<T>;
            list.Add(context);
            Current.Items["ActiveDbContext"] = list;
        }
        public static List<T> GetActiveDbContexts<T>()
        {
            var list = new List<T>();
            if (Current.Items["ActiveDbContext"].IsNotNull())
                list = Current.Items["ActiveDbContext"] as List<T>;
            return list;
        }
        public static void SetUserInfo(AppUser user)
        {
            Current.Items["ActiveUser"] = user;
        }
        public static bool IsValidUser(string ipAddress)
        {
            //return ipAddress == GetIPAddress();
            return true;
        }

        public static void SetDefaultUser()
        {
            var newUser = new AppUser
            {
                LogedId = -1,
                UserId = -1,
                Email = "System@System.com",
                UserName = "System",
                UserType = "System",
                UserAgent = "Windows",
                LogInDateTime = DateTime.Now.ToBD(),
                IPAddress = GetIPAddress(),
                EntrySource = "Portal",
                PartnerId = -1,
                ProductId = -1
            };
            SetUserInfo(newUser);
        }

        public static string GetIPAddress()
        {
            var ips = Current?.Connection?.RemoteIpAddress?.ToString();
            ips = ips.IsNotNullOrEmpty() ? ips.Split(',')[0] : Current?.Connection?.RemoteIpAddress?.MapToIPv4()?.ToString();
            if (ips.IsNullOrEmpty() || ips == "::1") ips = GetLocalIPAddress();
            return ips;
        }
        public static string GetLocalIPAddress()
        {
            var host = Dns.GetHostEntry(Dns.GetHostName());
            foreach (var ip in host.AddressList)
            {
                if (ip.AddressFamily == AddressFamily.InterNetwork)
                {
                    return ip.ToString();
                }
            }
            return "127.0.0.1";
        }
        public static string GetMachineName(string clientIP)
        {
            try
            {
                var hostEntry = Dns.GetHostEntry(clientIP);
                if (hostEntry.IsNull()) return "default";
                return hostEntry.HostName.IsNullOrEmpty() ? "default" : hostEntry.HostName;
            }
            catch
            {
                return "default";
            }
        }
        public static string GetUserAgent()
        {
            //var ua = Current.Request.UserAgent;
            var ua = "Windows";
            if (ua == null) return string.Empty;
            if (ua.Contains("Android"))
                return string.Format("Android {0}", GetMobileVersion(ua, "Android"));
            if (ua.Contains("iPad"))
                return string.Format("iPad OS {0}", GetMobileVersion(ua, "OS"));
            if (ua.Contains("iPhone"))
                return string.Format("iPhone OS {0}", GetMobileVersion(ua, "OS"));
            if (ua.Contains("Linux") && ua.Contains("KFAPWI"))
                return "Kindle Fire";
            if (ua.Contains("RIM Tablet") || (ua.Contains("BB") && ua.Contains("Mobile")))
                return "Black Berry";
            if (ua.Contains("Windows Phone"))
                return string.Format("Windows Phone {0}", GetMobileVersion(ua, "Windows Phone"));
            if (ua.Contains("Mac OS"))
                return "Mac OS";
            if (ua.Contains("Windows NT 5.1") || ua.Contains("Windows NT 5.2"))
                return "Windows XP";
            if (ua.Contains("Windows NT 6.0"))
                return "Windows Vista";
            if (ua.Contains("Windows NT 6.1"))
                return "Windows 7";
            if (ua.Contains("Windows NT 6.2"))
                return "Windows 8";
            if (ua.Contains("Windows NT 6.3"))
                return "Windows 8.1";
            if (ua.Contains("Windows NT 10"))
                return "Windows 10";
            //return Current.Request.Browser.Platform + (ua.Contains("Mobile") ? " Mobile " : "");
            return "Windows";
        }
        private static string GetMobileVersion(string userAgent, string device)
        {
            var temp = userAgent.Substring(userAgent.IndexOf(device, StringComparison.Ordinal) + device.Length).TrimStart();
            var version = string.Empty;
            foreach (var character in temp)
            {
                var validCharacter = false;
                int test;
                if (int.TryParse(character.ToString(), out test))
                {
                    version += character;
                    validCharacter = true;
                }
                if (character == '.' || character == '_')
                {
                    version += '.';
                    validCharacter = true;
                }

                if (validCharacter == false)
                    break;
            }
            return version;
        }
    }
}
