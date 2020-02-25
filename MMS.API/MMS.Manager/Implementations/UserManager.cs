using Core;
using MMS.DAL;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public class UserManager : ManagerBase, IUserManager
    {
        readonly IRepository<User> UserRepo;
        readonly IRepository<UserLogTracker> LogRepo;
        readonly IRepository<AssignedRole> ArRepo;
        readonly IRepository<AssignedPartner> ApRepo;
        readonly IModelAdapter Adapter;
        public UserManager(IRepository<User> userRepo,
            IRepository<UserLogTracker> logRepo,
            IRepository<AssignedRole> arRepo,
            IRepository<AssignedPartner> apRepo,
            IModelAdapter adapter)
        {
            UserRepo = userRepo;
            LogRepo = logRepo;
            ArRepo = arRepo;
            ApRepo = apRepo;
            Adapter = adapter;
        }

        public async Task<UserDto> SignIn(string email, string password, DateTime logInDate)
        {
            if (email.IsNullOrEmpty() || password.IsNullOrEmpty()) return null;
            var user = await UserRepo.SingleOrDefaultAsync(x => x.Email == email);
            if (user.IsNull()) return null;
            if (!VerifyPasswordHash(password, user.PasswordHash, user.PasswordSalt)) return null;
            var log = new UserLogTracker { UserId = user.UserId, IsLive = true, LogInAt = logInDate, IPAddress = AppContexts.GetIPAddress(), UserAgent = AppContexts.GetUserAgent(), ModelState = ModelState.Added };
            LogRepo.Add(log);
            LogRepo.SaveChanges();
            var userDto = user.MapTo<UserDto>();
            userDto.LogedId = log.LogedId;
            return userDto;
        }

        public async Task<List<UserDto>> GetUsers()
        {
            var users = await UserRepo.GetAllListAsync();
            return users.MapTo<List<UserDto>>();
        }

        public async Task<UserDto> GetUser(int userId)
        {
            var user = await UserRepo.GetAsync(userId);
            return user.MapTo<UserDto>();
        }
        public async Task<dynamic> GetPrivileges(int userId)
        {
            var Partners = await Adapter.GetAll($@"SELECT Checked = CAST(CASE WHEN AP.PartnerId IS NULL THEN 0 ELSE 1 END AS BIT), {userId} AS UserId, PA.PartnerId, PA.Name, CT.Name AS Country
	                                                    FROM [Partner] AS PA
                                                    LEFT JOIN Country AS CT ON PA.CountryId = CT.CountryId
                                                    LEFT JOIN (SELECT PartnerId FROM AssignedPartner WHERE UserId = @0) AS AP ON PA.PartnerId = AP.PartnerId
                                                    ORDER BY PA.SeqNo", userId);
            var Roles = await Adapter.GetAll($@"SELECT Checked = CAST(CASE WHEN AR.[Role] IS NULL THEN 0 ELSE 1 END AS BIT), {userId} AS UserId, CR.ConfigName AS Role
	                                                FROM Configuration AS CR
                                                LEFT JOIN (SELECT [Role] FROM AssignedRole WHERE UserId = @0) AS AR ON CR.ConfigName = AR.[Role]
                                                WHERE CR.ConfigType = 'AssignedRoles'
                                                ORDER BY CR.SeqNo", userId);

            return new { Partners, Roles };
        }
        public async Task<dynamic> GetUserPrivileges(int userId)
        {
            var Partners = await Adapter.GetAll(@"SELECT AP.*, PA.Name AS PartnerName, CT.Name AS Country
	                                                FROM AssignedPartner AS AP
                                                LEFT JOIN [Partner] AS PA ON AP.PartnerId = PA.PartnerId
                                                LEFT JOIN Country AS CT ON PA.CountryId = CT.CountryId
                                                WHERE UserId = @0", userId);
            var Roles = await Adapter.GetAll("SELECT * FROM AssignedRole WHERE UserId = @0", userId);

            return new { Partners, Roles };
        }
        public async Task<UserDto> GetByEmail(string email)
        {
            var user = await UserRepo.SingleOrDefaultAsync(x => x.Email == email);
            if (user.IsNull()) return null;
            var userDto = user.MapTo<UserDto>();
            return userDto;
        }

        public async Task SaveChanges(UserDto userDto)
        {
            if (userDto.IsAdded) userDto.UserId = 0;
            var userEnt = userDto.MapTo<User>();
            CreatePasswordHash(userDto.Password, out byte[] passwordHash, out byte[] passwordSalt);
            userEnt.PasswordHash = passwordHash;
            userEnt.PasswordSalt = passwordSalt;
            UserRepo.Add(userEnt);
            UserRepo.SaveChanges();
            userDto.UserId = userEnt.UserId;
            userDto.SetUnchanged();
            await Task.FromResult(0);
        }

        public async Task Delete(UserDto userDto)
        {
            var userEnt = userDto.MapTo<User>();
            UserRepo.Add(userEnt);
            UserRepo.SaveChanges();
            await Task.FromResult(0);
        }

        public async Task UpdateProfile(UserDto userDto)
        {
            var userEnt = userDto.MapTo<User>();
            UserRepo.Update<User>(new { userEnt.UserId, userEnt.FirstName, userEnt.LastName, UpdatedAt = DateTime.Now.ToBD(), UpdatedBy = AppContexts.User.UserId, UpdatedIP = AppContexts.User.IPAddress });
            await Task.FromResult(0);
        }

        public async Task SavePrivileges(int userId, List<AssignedRoleDto> roles, List<AssignedPartnerDto> partners)
        {
            if (roles.IsNull()) roles = new List<AssignedRoleDto>();
            if (partners.IsNull()) partners = new List<AssignedPartnerDto>();
            using (var unitOfWork = new UnitOfWork())
            {
                roles.ChangeState(ModelState.Added);
                partners.ChangeState(ModelState.Added);
                var roleEnts = roles.MapTo<List<AssignedRole>>();
                var partEnts = partners.MapTo<List<AssignedPartner>>();
                ArRepo.AddRange(roleEnts);
                ApRepo.AddRange(partEnts);
                ApRepo.ExecuteSqlCommand("DELETE AssignedPartner WHERE UserId = @p0; DELETE AssignedRole WHERE UserId = @p0;", userId);
                unitOfWork.CommitChanges();
            }
            await Task.FromResult(0);
        }

        public async Task ChangePassword(UserDto userDto)
        {
            var userEnt = userDto.MapTo<User>();
            CreatePasswordHash(userDto.Password, out byte[] passwordHash, out byte[] passwordSalt);
            userEnt.PasswordHash = passwordHash;
            userEnt.PasswordSalt = passwordSalt;
            UserRepo.Update<User>(new { userEnt.UserId, userEnt.PasswordHash, userEnt.PasswordSalt, UpdatedAt = DateTime.Now.ToBD(), UpdatedBy = AppContexts.User.UserId, UpdatedIP = AppContexts.User.IPAddress });
            await Task.FromResult(0);
        }

        public async Task<bool> ValidPassword(int userId, string password)
        {
            if (password.IsNullOrEmpty()) return false;
            var user = await UserRepo.GetAsync(userId);
            if (user.IsNull()) return false;
            return VerifyPasswordHash(password, user.PasswordHash, user.PasswordSalt);
        }

        public async Task SignOut(int logedId, DateTime signOutDate)
        {
            var log = new UserLogTracker { LogedId = logedId, LogOutAt = signOutDate, IsLive = false };
            LogRepo.Update<UserLogTracker>(new { log.LogedId, log.LogOutAt, log.IsLive });
            await Task.FromResult(0);
        }

        #region Helper Methods
        private static void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
        {
            if (password.IsNullOrEmpty()) throw new ArgumentException("Value cannot be empty or whitespace only string.", "password");
            using (var hmac = new System.Security.Cryptography.HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            }
        }

        private static bool VerifyPasswordHash(string password, byte[] storedHash, byte[] storedSalt)
        {
            if (password.IsNullOrEmpty()) throw new ArgumentException("Value cannot be empty or whitespace only string.", "password");
            if (storedHash.Length != 64) throw new ArgumentException("Invalid length of password hash (64 bytes expected).", "passwordHash");
            if (storedSalt.Length != 128) throw new ArgumentException("Invalid length of password salt (128 bytes expected).", "passwordHash");
            using (var hmac = new System.Security.Cryptography.HMACSHA512(storedSalt))
            {
                var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                for (int i = 0; i < computedHash.Length; i++)
                {
                    if (computedHash[i] != storedHash[i]) return false;
                }
            }
            return true;
        }
        #endregion
    }
}