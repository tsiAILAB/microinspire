using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(User)), Serializable]
    public class UserDto : Auditable
    {
        [JsonIgnore]
        public int LogedId { get; set; }
        private int userId;
        public int UserId
        {
            get
            {
                return userId;
            }
            set
            {
                if (PropertyChanged(userId, value))
                    userId = value;
            }
        }

        private string email;
        public string Email
        {
            get
            {
                return email;
            }
            set
            {
                if (PropertyChanged(email, value))
                    email = value;
            }
        }

        private string firstName;
        public string FirstName
        {
            get
            {
                return firstName;
            }
            set
            {
                if (PropertyChanged(firstName, value))
                    firstName = value;
            }
        }

        private string lastName;
        public string LastName
        {
            get
            {
                return lastName;
            }
            set
            {
                if (PropertyChanged(lastName, value))
                    lastName = value;
            }
        }

        private string userType;
        public string UserType
        {
            get
            {
                return userType;
            }
            set
            {
                if (PropertyChanged(userType, value))
                    userType = value;
            }
        }

        private int? organization;
        public int? Organization
        {
            get
            {
                return organization;
            }
            set
            {
                if (PropertyChanged(organization, value))
                    organization = value;
            }
        }

        private bool isActive;
        public bool IsActive
        {
            get
            {
                return isActive;
            }
            set
            {
                if (PropertyChanged(isActive, value))
                    isActive = value;
            }
        }

        public string UserName
        {
            get
            {
                return $"{firstName} {lastName}";
            }
        }
        public string Password { get; set; }
        public string OldPassword { get; set; }
    }
}