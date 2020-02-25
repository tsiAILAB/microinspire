using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Core;
using MMS.Manager;
using System;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [Authorize, ApiController, Route("[controller]/[action]")]
    public class UserController : BaseController
    {
        readonly AppSettings appSettings;
        readonly IUserManager Manager;

        public UserController(IUserManager manager, IOptions<AppSettings> appSettings)
        {
            Manager = manager;
            this.appSettings = appSettings.Value;
        }
        // POST: /User/SignIn
        [AllowAnonymous, HttpPost]
        public async Task<IActionResult> SignIn([FromBody]LoginUser user)
        {
            var logInDate = DateTime.Now.ToBD();
            var logUser = await Manager.SignIn(user.Email, user.Password, logInDate);
            if (logUser.IsNull()) return BadRequestResult("Email or password is incorrect.");
            if (!logUser.IsActive) return BadRequestResult("The user is inactive.");
            var appUser = new AppUser { LogedId = logUser.LogedId, UserId = logUser.UserId, UserName = logUser.UserName, Email = logUser.Email, UserType = logUser.UserType, LogInDateTime = logInDate, IPAddress = AppContexts.GetIPAddress(), EntrySource = "Portal", PartnerId = -1, ProductId = -1 };
            var tokenString = TokenUtil.GenerateToken(appUser, appSettings.Secret);
            return OkResult(new
            {
                logUser.LogedId,
                logUser.UserId,
                logUser.Email,
                logUser.UserName,
                logUser.UserType,
                DateFormat = Util.SysDateFormat,
                Token = tokenString
            });
        }

        // GET: /User/GetAll
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var users = await Manager.GetUsers();
            if (users.IsNull() || users.Count.IsZero()) return NoContentResult("There is no user.");
            return OkResult(users);
        }
        // GET: /User/Get
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var user = await Manager.GetUser(AppContexts.User.UserId);
            return OkResult(user);
        }
        // GET: /User/GetPrivileges/{userId}
        [HttpGet("{userId:int}")]
        public async Task<IActionResult> GetPrivileges(int userId)
        {
            var privileges = await Manager.GetPrivileges(userId);
            return OkResult(privileges);
        }
        // GET: /User/GetUserPrivileges
        [HttpGet]
        public async Task<IActionResult> GetUserPrivileges()
        {
            var privileges = await Manager.GetUserPrivileges(AppContexts.User.UserId);
            return OkResult(privileges);
        }
        // GET: /User/Get/{userId}
        [HttpGet("{userId:int}")]
        public async Task<IActionResult> Get(int userId)
        {
            if (userId.LessThen(1)) return ValidationResult("User Id can't less then 1.");
            var user = await Manager.GetUser(userId);
            if (user.IsNull()) return NotFoundResult($"User with id '{userId}' not found.");
            return OkResult(user);
        }
        // GET: /User/GetUser/{email}
        [HttpGet("{email}")]
        public async Task<IActionResult> GetUser(string email)
        {
            if (email.IsNullOrDbNull()) return ValidationResult("Email can't be empty.");
            var user = await Manager.GetByEmail(email);
            if (user.IsNull()) user = new UserDto { Email = email, UserType = "Standard", ModelState = DAL.ModelState.Added };
            return OkResult(user);
        }
        // POST: /User/SaveChanges
        [HttpPost]
        public async Task<IActionResult> SaveChanges([FromBody]UserDto user)
        {
            var isAdded = user.IsAdded;
            if (!isAdded && user.UserId.LessThen(1)) return ValidationResult("User Id can't less then 1.");
            if (!isAdded) user.SetModified();
            await Manager.SaveChanges(user);
            if (isAdded)
                return CreatedResult(user);
            else
                return UpdatedResult(user);
        }
        // POST: /User/Delete
        [HttpPost]
        public async Task<IActionResult> Delete([FromBody]UserDto user)
        {
            if (user.UserId.LessThen(1)) return ValidationResult("User Id can't less then 1.");
            await Manager.Delete(user);
            return DeletedResult();
        }
        // POST: /User/UpdateProfile
        [HttpPost]
        public async Task<IActionResult> UpdateProfile([FromBody]UserDto user)
        {
            user.UserId = AppContexts.User.UserId;
            await Manager.UpdateProfile(user);
            return OkResult();
        }
        // POST: /User/ChangePassword
        [HttpPost]
        public async Task<IActionResult> ChangePassword([FromBody]UserDto user)
        {
            user.UserId = AppContexts.User.UserId;
            if (!await Manager.ValidPassword(user.UserId, user.OldPassword)) return ValidationResult("Invalid Old password");
            await Manager.ChangePassword(user);
            return OkResult();
        }
        // POST: /User/SavePrivileges
        [HttpPost]
        public async Task<IActionResult> SavePrivileges([FromBody]UserPrivilege privileges)
        {
            await Manager.SavePrivileges(privileges.UserId, privileges.Roles, privileges.Partners);
            return OkResult();
        }
        // GET: /User/SignOut
        [HttpGet]
        public async Task<ActionResult> SignOut()
        {
            await Manager.SignOut(AppContexts.User.LogedId, DateTime.Now.ToBD());
            return OkResult();
        }
    }
}
