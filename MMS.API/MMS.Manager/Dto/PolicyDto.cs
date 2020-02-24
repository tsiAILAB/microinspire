using MMS.Core;
using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
	[AutoMap(typeof(Policy)), Serializable]
	public class PolicyDto : Auditable
	{

		private int policyId;
		public int PolicyId 
		{
			get
			{
				return policyId;
			}
			set
			{
				if (PropertyChanged(policyId, value))
					policyId = value;
			}
		}

		private string policyNumber;
		public string PolicyNumber 
		{
			get
			{
				return policyNumber;
			}
			set
			{
				if (PropertyChanged(policyNumber, value))
					policyNumber = value;
			}
		}

		private int partnerId;
		public int PartnerId 
		{
			get
			{
				return partnerId;
			}
			set
			{
				if (PropertyChanged(partnerId, value))
					partnerId = value;
			}
		}

		private int productId;
		public int ProductId 
		{
			get
			{
				return productId;
			}
			set
			{
				if (PropertyChanged(productId, value))
					productId = value;
			}
		}

		private int benefitId;
		public int BenefitId 
		{
			get
			{
				return benefitId;
			}
			set
			{
				if (PropertyChanged(benefitId, value))
					benefitId = value;
			}
		}

		private DateTime policyStart;
		[JsonConverter(typeof(DateConverter))]
		public DateTime PolicyStart 
		{
			get
			{
				return policyStart;
			}
			set
			{
				if (PropertyChanged(policyStart, value))
					policyStart = value;
			}
		}

        private DateTime? policyEnd;
        [JsonConverter(typeof(DateConverter))]
        public DateTime? PolicyEnd
        {
            get
            {
                return policyEnd;
            }
            set
            {
                if (PropertyChanged(policyEnd, value))
                    policyEnd = value;
            }
        }

        private string salesReference;
		public string SalesReference 
		{
			get
			{
				return salesReference;
			}
			set
			{
				if (PropertyChanged(salesReference, value))
					salesReference = value;
			}
		}

		private string contributionExtRef;
		public string ContributionExtRef 
		{
			get
			{
				return contributionExtRef;
			}
			set
			{
				if (PropertyChanged(contributionExtRef, value))
					contributionExtRef = value;
			}
		}

		private string externalId;
		public string ExternalId 
		{
			get
			{
				return externalId;
			}
			set
			{
				if (PropertyChanged(externalId, value))
					externalId = value;
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

		private DateTime? coverStartDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? CoverStartDate 
		{
			get
			{
				return coverStartDate;
			}
			set
			{
				if (PropertyChanged(coverStartDate, value))
					coverStartDate = value;
			}
		}

		private int? termMonths;
		public int? TermMonths 
		{
			get
			{
				return termMonths;
			}
			set
			{
				if (PropertyChanged(termMonths, value))
					termMonths = value;
			}
		}

		private DateTime? coverEndDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? CoverEndDate 
		{
			get
			{
				return coverEndDate;
			}
			set
			{
				if (PropertyChanged(coverEndDate, value))
					coverEndDate = value;
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

		private string category;
		public string Category 
		{
			get
			{
				return category;
			}
			set
			{
				if (PropertyChanged(category, value))
					category = value;
			}
		}

		private string officerId;
		public string OfficerId 
		{
			get
			{
				return officerId;
			}
			set
			{
				if (PropertyChanged(officerId, value))
					officerId = value;
			}
		}

		private string officerName;
		public string OfficerName 
		{
			get
			{
				return officerName;
			}
			set
			{
				if (PropertyChanged(officerName, value))
					officerName = value;
			}
		}

		private string centreLocation;
		public string CentreLocation 
		{
			get
			{
				return centreLocation;
			}
			set
			{
				if (PropertyChanged(centreLocation, value))
					centreLocation = value;
			}
		}

		private string cycle;
		public string Cycle 
		{
			get
			{
				return cycle;
			}
			set
			{
				if (PropertyChanged(cycle, value))
					cycle = value;
			}
		}

        private DateTime? requestedEndDate;
        [JsonConverter(typeof(DateConverter))]
        public DateTime? RequestedEndDate
        {
            get
            {
                return requestedEndDate;
            }
            set
            {
                if (PropertyChanged(requestedEndDate, value))
                    requestedEndDate = value;
            }
        }

        private string endReason;
        public string EndReason
        {
            get
            {
                return endReason;
            }
            set
            {
                if (PropertyChanged(endReason, value))
                    endReason = value;
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

        private string policyStatus;
		public string PolicyStatus 
		{
			get
			{
				return policyStatus;
			}
			set
			{
				if (PropertyChanged(policyStatus, value))
					policyStatus = value;
			}
		}

        public string PartnerName { get; set; }
        public string ProductName { get; set; }
        public string BenefitName { get; set; }

    }
}