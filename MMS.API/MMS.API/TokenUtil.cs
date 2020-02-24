using Microsoft.IdentityModel.Tokens;
using MMS.Core;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace MMS.API
{
    public static class TokenUtil
    {
        public static string GenerateToken(AppUser user, string secret, DateTime? expires = null)
        {
            if (expires.IsNullOrMinValue()) expires = DateTime.Now.ToBD().AddDays(30);
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(secret);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Issuer = "MicroInspire",
                Audience = "MicroInspire",
                Subject = new ClaimsIdentity(new Claim[]
                {
                        new Claim(ClaimTypes.Name, user.UserName),
                        new Claim("LogedId", user.LogedId.ToString()),
                        new Claim("UserId", user.UserId.ToString()),
                        new Claim("Email", user.Email),
                        new Claim("UserType", user.UserType),
                        new Claim("LogInDateTime",user.LogInDateTime.ToString()),
                        new Claim("IPAddress", user.IPAddress),
                        new Claim("EntrySource", user.EntrySource),
                        new Claim("PartnerId", user.PartnerId.ToString()),
                        new Claim("ProductId", user.ProductId.ToString())
                }),
                Expires = expires,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            var tokenString = tokenHandler.WriteToken(token);
            return tokenString;
        }
    }
}
