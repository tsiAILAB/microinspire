using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("Policy")]
    public class Policy : Auditable
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int PolicyId { get; set; }
        [Required(ErrorMessage = "Policy number is required.")]
        public string PolicyNumber { get; set; }

        public int PartnerId { get; set; }

        public int ProductId { get; set; }

        public int BenefitId { get; set; }
        [Column(TypeName = "date")]
        public DateTime PolicyStart { get; set; }
        [Column(TypeName = "date")]
        public DateTime? PolicyEnd { get; set; }
        [Required(ErrorMessage = "Sales reference is required.")]
        public string SalesReference { get; set; }

        public string ContributionExtRef { get; set; }
        [Required(ErrorMessage = "External id is required.")]
        public string ExternalId { get; set; }

        public decimal? LoanAmount { get; set; }
        [Column(TypeName = "date")]
        public DateTime? CoverStartDate { get; set; }

        public int? TermMonths { get; set; }
        [Column(TypeName = "date")]
        public DateTime? CoverEndDate { get; set; }

        public string AccountNo { get; set; }

        public string Category { get; set; }

        public string OfficerId { get; set; }

        public string OfficerName { get; set; }

        public string CentreLocation { get; set; }

        public string Cycle { get; set; }

        [Column(TypeName = "date")]
        public DateTime? RequestedEndDate { get; set; }
        public string EndReason { get; set; }
        public string EntrySource { get; set; }
        [Required(ErrorMessage = "Policy status is required.")]
        public string PolicyStatus { get; set; }        

    }
}