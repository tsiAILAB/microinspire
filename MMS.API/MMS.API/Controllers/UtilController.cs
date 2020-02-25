using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Core;
using MMS.Manager;
using System;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [ApiController, Route("[controller]/[action]")]
    public class UtilController : BaseController
    {
        readonly AppSettings appSettings;

        public UtilController(IOptions<AppSettings> appSettings)
        {
            this.appSettings = appSettings.Value;
        }
        [AllowAnonymous, HttpGet]
        public async Task<IActionResult> TestAPI()
        {
            return await Task.FromResult(OkResult());
        }

        [AllowAnonymous, HttpPost]
        public async Task<IActionResult> Encrypt(ConnectionModel connection)
        {
            if (connection.Name.IsNotNullOrEmpty()
                && connection.Key.IsNotNullOrEmpty()
                && connection.Key.Equals("mamunmms"))
            {
                var hashKey = Encryption.GetHashKey(connection.Name);
                connection.ConnectionString = Encryption.Encrypt(hashKey, connection.ConnectionString);
            }
            return await Task.FromResult(OkResult(connection));
        }
        [AllowAnonymous, HttpPost]
        public async Task<IActionResult> GenerateToken(AgentUsersDto user)
        {
            var tokenString = string.Empty;
            if (user.UserName.IsNotNullOrEmpty()
                && user.Key.IsNotNullOrEmpty()
                && user.Key.Equals("mamunmms"))
            {
                var appUser = new AppUser { LogedId = -1, UserId = user.UserId, UserName = user.UserName, Email = user.Email, UserType = "API", LogInDateTime = DateTime.Now.ToBD(), IPAddress = AppContexts.GetIPAddress(), EntrySource = "External", PartnerId = user.PartnerId.GetValueOrDefault(-1), ProductId = user.ProductId.GetValueOrDefault(-1) };
                tokenString = TokenUtil.GenerateToken(appUser, appSettings.Secret, DateTime.Now.ToBD().AddYears(5));

            }
            return await Task.FromResult(OkResult(tokenString));
        }
    }
}
