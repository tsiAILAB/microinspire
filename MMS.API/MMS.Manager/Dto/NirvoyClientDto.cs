using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(NirvoyClient)), Serializable]
    public class NirvoyClientDto : Auditable
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

        private string name;
        public string Name
        {
            get
            {
                return name;
            }
            set
            {
                if (PropertyChanged(name, value))
                    name = value;
            }
        }

        private string mobileNumber;
        public string MobileNumber
        {
            get
            {
                return mobileNumber;
            }
            set
            {
                if (PropertyChanged(mobileNumber, value))
                    mobileNumber = value;
            }
        }

        private int age;
        public int Age
        {
            get
            {
                return age;
            }
            set
            {
                if (PropertyChanged(age, value))
                    age = value;
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

        private string beneName;
        public string BeneName
        {
            get
            {
                return beneName;
            }
            set
            {
                if (PropertyChanged(beneName, value))
                    beneName = value;
            }
        }

        private string beneMobileNumber;
        public string BeneMobileNumber
        {
            get
            {
                return beneMobileNumber;
            }
            set
            {
                if (PropertyChanged(beneMobileNumber, value))
                    beneMobileNumber = value;
            }
        }

        private int? beneAge;
        public int? BeneAge
        {
            get
            {
                return beneAge;
            }
            set
            {
                if (PropertyChanged(beneAge, value))
                    beneAge = value;
            }
        }

        private string beneRelationship;
        public string BeneRelationship
        {
            get
            {
                return beneRelationship;
            }
            set
            {
                if (PropertyChanged(beneRelationship, value))
                    beneRelationship = value;
            }
        }

        private decimal? loanAmount;
        public decimal? LoanAmount
        {
            get
            {
                return loanAmount;
            }
            set
            {
                if (PropertyChanged(loanAmount, value))
                    loanAmount = value;
            }
        }

        private string deviceOwnership;
        public string DeviceOwnership
        {
            get
            {
                return deviceOwnership;
            }
            set
            {
                if (PropertyChanged(deviceOwnership, value))
                    deviceOwnership = value;
            }
        }

        private bool acceptsTerms;
        public bool AcceptsTerms
        {
            get
            {
                return acceptsTerms;
            }
            set
            {
                if (PropertyChanged(acceptsTerms, value))
                    acceptsTerms = value;
            }
        }

        private bool? thirdPartyAuthorized = true;
        public bool? ThirdPartyAuthorized
        {
            get
            {
                return thirdPartyAuthorized;
            }
            set
            {
                if (PropertyChanged(thirdPartyAuthorized, value))
                    thirdPartyAuthorized = value;
            }
        }

        private string subscriptionChannel = "Self Registration";
        public string SubscriptionChannel
        {
            get
            {
                return subscriptionChannel;
            }
            set
            {
                if (PropertyChanged(subscriptionChannel, value))
                    subscriptionChannel = value;
            }
        }

        private string agentMobileNumber;
        public string AgentMobileNumber
        {
            get
            {
                return agentMobileNumber;
            }
            set
            {
                if (PropertyChanged(agentMobileNumber, value))
                    agentMobileNumber = value;
            }
        }

        private string entrySource;
        public string EntrySource
        {
            get
            {
                return entrySource;
            }
            set
            {
                if (PropertyChanged(entrySource, value))
                    entrySource = value;
            }
        }

        private string status = "Registered";
        public string Status
        {
            get
            {
                return status;
            }
            set
            {
                if (PropertyChanged(status, value))
                    status = value;
            }
        }

    }
}