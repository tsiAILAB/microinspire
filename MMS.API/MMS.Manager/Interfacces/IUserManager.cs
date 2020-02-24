using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public interface IUserManager
    {
        Task<UserDto> SignIn(string email, string password, DateTime logInDate);
        Task<List<UserDto>> GetUsers();
        Task<UserDto> GetUser(int userId);
        Task<dynamic> GetPrivileges(int userId);
        Task<dynamic> GetUserPrivileges(int userId);
        Task<UserDto> GetByEmail(string email);
        Task SaveChanges(UserDto userDto);
        Task Delete(UserDto userDto);
        Task UpdateProfile(UserDto userDto);
        Task ChangePassword(UserDto userDto);
        Task SavePrivileges(int userId, List<AssignedRoleDto> roles, List<AssignedPartnerDto> partners);
        Task<bool> ValidPassword(int userId, string password);
        Task SignOut(int logedId, DateTime signOutDate);
    }    
}