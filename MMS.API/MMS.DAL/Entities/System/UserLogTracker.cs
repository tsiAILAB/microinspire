using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MMS.DAL
{
    [Table("UserLogTracker"), Serializable]
    public class UserLogTracker : EntityBase
    {
        [Key]
        public int LogedId { get; set; }
        public int UserId { get; set; }
        public DateTime LogInAt { get; set; }
        public DateTime? LogOutAt { get; set; }
        public bool? IsLive { get; set; }
        public string IPAddress { get; set; }
        public string UserAgent { get; set; }
    }
}