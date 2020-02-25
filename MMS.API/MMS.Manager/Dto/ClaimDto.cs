using Core;
using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
	[AutoMap(typeof(Claim)), Serializable]
	public class ClaimDto : Auditable
	{

		private int claimId;
		public int ClaimId 
		{
			get
			{
				return claimId;
			}
			set
			{
				if (PropertyChanged(claimId, value))
					claimId = value;
			}
		}

		private string claimNumber;
		public string ClaimNumber 
		{
			get
			{
				return claimNumber;
			}
			set
			{
				if (PropertyChanged(claimNumber, value))
					claimNumber = value;
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

		private int businessId;
		public int BusinessId 
		{
			get
			{
				return businessId;
			}
			set
			{
				if (PropertyChanged(businessId, value))
					businessId = value;
			}
		}

		private int? underWriterId;
		public int? UnderWriterId 
		{
			get
			{
				return underWriterId;
			}
			set
			{
				if (PropertyChanged(underWriterId, value))
					underWriterId = value;
			}
		}

		private int? policyId;
		public int? PolicyId 
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

		private int? insuredId;
		public int? InsuredId 
		{
			get
			{
				return insuredId;
			}
			set
			{
				if (PropertyChanged(insuredId, value))
					insuredId = value;
			}
		}

		private int? notifierId;
		public int? NotifierId 
		{
			get
			{
				return notifierId;
			}
			set
			{
				if (PropertyChanged(notifierId, value))
					notifierId = value;
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

		private decimal? coverAmount;
		public decimal? CoverAmount 
		{
			get
			{
				return coverAmount;
			}
			set
			{
				if (PropertyChanged(coverAmount, value))
					coverAmount = value;
			}
		}

		private decimal? revisedCoverAmount;
		public decimal? RevisedCoverAmount 
		{
			get
			{
				return revisedCoverAmount;
			}
			set
			{
				if (PropertyChanged(revisedCoverAmount, value))
					revisedCoverAmount = value;
			}
		}

		private DateTime? dateOfIncident;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? DateOfIncident 
		{
			get
			{
				return dateOfIncident;
			}
			set
			{
				if (PropertyChanged(dateOfIncident, value))
					dateOfIncident = value;
			}
		}

		private DateTime? dateNotified;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? DateNotified 
		{
			get
			{
				return dateNotified;
			}
			set
			{
				if (PropertyChanged(dateNotified, value))
					dateNotified = value;
			}
		}

		private DateTime? documentCompleteDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? DocumentCompleteDate 
		{
			get
			{
				return documentCompleteDate;
			}
			set
			{
				if (PropertyChanged(documentCompleteDate, value))
					documentCompleteDate = value;
			}
		}

		private DateTime? reminderDueDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? ReminderDueDate 
		{
			get
			{
				return reminderDueDate;
			}
			set
			{
				if (PropertyChanged(reminderDueDate, value))
					reminderDueDate = value;
			}
		}

		private string reminderComment;
		public string ReminderComment 
		{
			get
			{
				return reminderComment;
			}
			set
			{
				if (PropertyChanged(reminderComment, value))
					reminderComment = value;
			}
		}

		private bool? uWReviewRequired;
		public bool? UWReviewRequired 
		{
			get
			{
				return uWReviewRequired;
			}
			set
			{
				if (PropertyChanged(uWReviewRequired, value))
					uWReviewRequired = value;
			}
		}

		private decimal? approvedAmount;
		public decimal? ApprovedAmount 
		{
			get
			{
				return approvedAmount;
			}
			set
			{
				if (PropertyChanged(approvedAmount, value))
					approvedAmount = value;
			}
		}

		private string decision;
		public string Decision 
		{
			get
			{
				return decision;
			}
			set
			{
				if (PropertyChanged(decision, value))
					decision = value;
			}
		}

		private string rejectionReason;
		public string RejectionReason 
		{
			get
			{
				return rejectionReason;
			}
			set
			{
				if (PropertyChanged(rejectionReason, value))
					rejectionReason = value;
			}
		}

		private int? reviewBy;
		public int? ReviewBy 
		{
			get
			{
				return reviewBy;
			}
			set
			{
				if (PropertyChanged(reviewBy, value))
					reviewBy = value;
			}
		}

		private DateTime? reviewDate;
		[JsonConverter(typeof(DateTimeConverter))]
		public DateTime? ReviewDate 
		{
			get
			{
				return reviewDate;
			}
			set
			{
				if (PropertyChanged(reviewDate, value))
					reviewDate = value;
			}
		}

		private int? confirmedBy;
		public int? ConfirmedBy 
		{
			get
			{
				return confirmedBy;
			}
			set
			{
				if (PropertyChanged(confirmedBy, value))
					confirmedBy = value;
			}
		}

		private DateTime? confirmedDate;
		[JsonConverter(typeof(DateTimeConverter))]
		public DateTime? ConfirmedDate 
		{
			get
			{
				return confirmedDate;
			}
			set
			{
				if (PropertyChanged(confirmedDate, value))
					confirmedDate = value;
			}
		}

		private DateTime? uWSentDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? UWSentDate 
		{
			get
			{
				return uWSentDate;
			}
			set
			{
				if (PropertyChanged(uWSentDate, value))
					uWSentDate = value;
			}
		}

		private string uWExternalRef;
		public string UWExternalRef 
		{
			get
			{
				return uWExternalRef;
			}
			set
			{
				if (PropertyChanged(uWExternalRef, value))
					uWExternalRef = value;
			}
		}

		private string uWStatus;
		public string UWStatus 
		{
			get
			{
				return uWStatus;
			}
			set
			{
				if (PropertyChanged(uWStatus, value))
					uWStatus = value;
			}
		}

		private DateTime? uWAdviceDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? UWAdviceDate 
		{
			get
			{
				return uWAdviceDate;
			}
			set
			{
				if (PropertyChanged(uWAdviceDate, value))
					uWAdviceDate = value;
			}
		}

		private string uWAdviceFrom;
		public string UWAdviceFrom 
		{
			get
			{
				return uWAdviceFrom;
			}
			set
			{
				if (PropertyChanged(uWAdviceFrom, value))
					uWAdviceFrom = value;
			}
		}

		private string uWAdviceRef;
		public string UWAdviceRef 
		{
			get
			{
				return uWAdviceRef;
			}
			set
			{
				if (PropertyChanged(uWAdviceRef, value))
					uWAdviceRef = value;
			}
		}

		private decimal? uWApprovedAmount;
		public decimal? UWApprovedAmount 
		{
			get
			{
				return uWApprovedAmount;
			}
			set
			{
				if (PropertyChanged(uWApprovedAmount, value))
					uWApprovedAmount = value;
			}
		}

		private string uWDecision;
		public string UWDecision 
		{
			get
			{
				return uWDecision;
			}
			set
			{
				if (PropertyChanged(uWDecision, value))
					uWDecision = value;
			}
		}

		private string uWRejectionReason;
		public string UWRejectionReason 
		{
			get
			{
				return uWRejectionReason;
			}
			set
			{
				if (PropertyChanged(uWRejectionReason, value))
					uWRejectionReason = value;
			}
		}

		private int? uWReviewBy;
		public int? UWReviewBy 
		{
			get
			{
				return uWReviewBy;
			}
			set
			{
				if (PropertyChanged(uWReviewBy, value))
					uWReviewBy = value;
			}
		}

		private DateTime? uWReviewDate;
		[JsonConverter(typeof(DateTimeConverter))]
		public DateTime? UWReviewDate 
		{
			get
			{
				return uWReviewDate;
			}
			set
			{
				if (PropertyChanged(uWReviewDate, value))
					uWReviewDate = value;
			}
		}

		private int? uWConfirmedBy;
		public int? UWConfirmedBy 
		{
			get
			{
				return uWConfirmedBy;
			}
			set
			{
				if (PropertyChanged(uWConfirmedBy, value))
					uWConfirmedBy = value;
			}
		}

		private DateTime? uWConfirmedDate;
		[JsonConverter(typeof(DateTimeConverter))]
		public DateTime? UWConfirmedDate 
		{
			get
			{
				return uWConfirmedDate;
			}
			set
			{
				if (PropertyChanged(uWConfirmedDate, value))
					uWConfirmedDate = value;
			}
		}

		private bool? uWRefundPending;
		public bool? UWRefundPending 
		{
			get
			{
				return uWRefundPending;
			}
			set
			{
				if (PropertyChanged(uWRefundPending, value))
					uWRefundPending = value;
			}
		}

		private bool? claimPaidInPart;
		public bool? ClaimPaidInPart 
		{
			get
			{
				return claimPaidInPart;
			}
			set
			{
				if (PropertyChanged(claimPaidInPart, value))
					claimPaidInPart = value;
			}
		}

		private string paymentTATDetails;
		public string PaymentTATDetails 
		{
			get
			{
				return paymentTATDetails;
			}
			set
			{
				if (PropertyChanged(paymentTATDetails, value))
					paymentTATDetails = value;
			}
		}

		private DateTime? paymentDueDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? PaymentDueDate 
		{
			get
			{
				return paymentDueDate;
			}
			set
			{
				if (PropertyChanged(paymentDueDate, value))
					paymentDueDate = value;
			}
		}

		private string closureReason;
		public string ClosureReason 
		{
			get
			{
				return closureReason;
			}
			set
			{
				if (PropertyChanged(closureReason, value))
					closureReason = value;
			}
		}

		private DateTime? closureDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? ClosureDate 
		{
			get
			{
				return closureDate;
			}
			set
			{
				if (PropertyChanged(closureDate, value))
					closureDate = value;
			}
		}

		private string claimStatus;
		public string ClaimStatus 
		{
			get
			{
				return claimStatus;
			}
			set
			{
				if (PropertyChanged(claimStatus, value))
					claimStatus = value;
			}
		}

        private DateTime? statusCreated;
        [JsonConverter(typeof(SystemDateTimeConverter))]
        public DateTime? StatusCreated
        {
            get
            {
                return statusCreated;
            }
            set
            {
                if (PropertyChanged(statusCreated, value))
                    statusCreated = value;
            }
        }

    }
}