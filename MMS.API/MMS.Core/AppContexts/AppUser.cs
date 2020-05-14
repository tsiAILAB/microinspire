using System;

namespace Core
{
    public class AppUser
    {
        public int LogedId { get; set; }
        public int UserId { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string UserType { get; set; }
        public string IPAddress { get; set; }
        public string UserAgent { get; set; }
        public string EntrySource { get; set; }
        public DateTime LogInDateTime { get; set; }
        public int PartnerId { get; set; }
        public int ProductId { get; set; }
    }
    
}