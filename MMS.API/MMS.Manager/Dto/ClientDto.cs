using Core;
using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(Client)), Serializable]
    public class ClientDto : Auditable
    {

        private int clientId;
        public int ClientId
        {
            get
            {
                return clientId;
            }
            set
            {
                if (PropertyChanged(clientId, value))
                    clientId = value;
            }
        }

        private string clientType;
        public string ClientType
        {
            get
            {
                return clientType;
            }
            set
            {
                if (PropertyChanged(clientType, value))
                    clientType = value;
            }
        }

        private string relationship;
        public string Relationship
        {
            get
            {
                return relationship;
            }
            set
            {
                if (PropertyChanged(relationship, value))
                    relationship = value;
            }
        }

        private int? ageAtCreationDate;
        public int? AgeAtCreationDate
        {
            get
            {
                return ageAtCreationDate;
            }
            set
            {
                if (PropertyChanged(ageAtCreationDate, value))
                    ageAtCreationDate = value;
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

        private string mobileNo;
        public string MobileNo
        {
            get
            {
                return mobileNo;
            }
            set
            {
                if (PropertyChanged(mobileNo, value))
                    mobileNo = value;
            }
        }

        private string accountNo;
        public string AccountNo
        {
            get
            {
                return accountNo;
            }
            set
            {
                if (PropertyChanged(accountNo, value))
                    accountNo = value;
            }
        }

        private DateTime? dateofBirth;
        [JsonConverter(typeof(DateConverter))]
        public DateTime? DateofBirth
        {
            get
            {
                return dateofBirth;
            }
            set
            {
                if (PropertyChanged(dateofBirth, value))
                    dateofBirth = value;
            }
        }

        private string gender;
        public string Gender
        {
            get
            {
                return gender;
            }
            set
            {
                if (PropertyChanged(gender, value))
                    gender = value;
            }
        }

        private string maritalStatus;
        public string MaritalStatus
        {
            get
            {
                return maritalStatus;
            }
            set
            {
                if (PropertyChanged(maritalStatus, value))
                    maritalStatus = value;
            }
        }

        private string personalIdType;
        public string PersonalIdType
        {
            get
            {
                return personalIdType;
            }
            set
            {
                if (PropertyChanged(personalIdType, value))
                    personalIdType = value;
            }
        }

        private string personalId;
        public string PersonalId
        {
            get
            {
                return personalId;
            }
            set
            {
                if (PropertyChanged(personalId, value))
                    personalId = value;
            }
        }

        private string address;
        public string Address
        {
            get
            {
                return address;
            }
            set
            {
                if (PropertyChanged(address, value))
                    address = value;
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

        private string location;
        public string Location
        {
            get
            {
                return location;
            }
            set
            {
                if (PropertyChanged(location, value))
                    location = value;
            }
        }

        private string language;
        public string Language
        {
            get
            {
                return language;
            }
            set
            {
                if (PropertyChanged(language, value))
                    language = value;
            }
        }

        private string postalCode;
        public string PostalCode
        {
            get
            {
                return postalCode;
            }
            set
            {
                if (PropertyChanged(postalCode, value))
                    postalCode = value;
            }
        }

        private string communication;
        public string Communication
        {
            get
            {
                return communication;
            }
            set
            {
                if (PropertyChanged(communication, value))
                    communication = value;
            }
        }

        public int PCId { get; set; }

        public int PolicyId { get; set; }

        public int ClaimId { get; set; }
        [JsonConverter(typeof(DateConverter))]
        public DateTime? DateNotified { get; set; }

        public bool Editable { get; set; }

    }
}