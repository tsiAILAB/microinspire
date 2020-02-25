using Core;
using Newtonsoft.Json;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("Claim")]
	public class Claim : Auditable
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public int ClaimId { get; set; }
		[Required]
		public string ClaimNumber { get; set; }
		
		public int PartnerId { get; set; }
		
		public int ProductId { get; set; }
		
		public int BusinessId { get; set; }
		
		public int? UnderWriterId { get; set; }
		
		public int? PolicyId { get; set; }
		
		public int? InsuredId { get; set; }
		
		public int? NotifierId { get; set; }
		[Column(TypeName = "date")]
		public DateTime? CoverStartDate { get; set; }
		[Column(TypeName = "date")]
		public DateTime? CoverEndDate { get; set; }
		
		public decimal? CoverAmount { get; set; }
		
		public decimal? RevisedCoverAmount { get; set; }
		[Column(TypeName = "date")]
		public DateTime? DateOfIncident { get; set; }
		[Column(TypeName = "date")]
		public DateTime? DateNotified { get; set; }
		[Column(TypeName = "date")]
		public DateTime? DocumentCompleteDate { get; set; }
		[Column(TypeName = "date")]
		public DateTime? ReminderDueDate { get; set; }
		
		public string ReminderComment { get; set; }
		
		public bool? UWReviewRequired { get; set; }
		
		public decimal? ApprovedAmount { get; set; }
		
		public string Decision { get; set; }
		
		public string RejectionReason { get; set; }
		
		public int? ReviewBy { get; set; }
		
		public DateTime? ReviewDate { get; set; }
		
		public int? ConfirmedBy { get; set; }
		
		public DateTime? ConfirmedDate { get; set; }
		[Column(TypeName = "date")]
		public DateTime? UWSentDate { get; set; }
		
		public string UWExternalRef { get; set; }
		
		public string UWStatus { get; set; }
		[Column(TypeName = "date")]
		public DateTime? UWAdviceDate { get; set; }
		
		public string UWAdviceFrom { get; set; }
		
		public string UWAdviceRef { get; set; }
		
		public decimal? UWApprovedAmount { get; set; }
		
		public string UWDecision { get; set; }
		
		public string UWRejectionReason { get; set; }
		
		public int? UWReviewBy { get; set; }
		
		public DateTime? UWReviewDate { get; set; }
		
		public int? UWConfirmedBy { get; set; }
		
		public DateTime? UWConfirmedDate { get; set; }
		
		public bool? UWRefundPending { get; set; }
		
		public bool? ClaimPaidInPart { get; set; }
		
		public string PaymentTATDetails { get; set; }
		[Column(TypeName = "date")]
		public DateTime? PaymentDueDate { get; set; }
		
		public string ClosureReason { get; set; }
		[Column(TypeName = "date")]
		public DateTime? ClosureDate { get; set; }
		[Required]
		public string ClaimStatus { get; set; }
        [JsonConverter(typeof(SystemDateTimeConverter))]
        public DateTime? StatusCreated { get; set; }

    }
}