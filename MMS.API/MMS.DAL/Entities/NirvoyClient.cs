using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
    [Table("NirvoyClient")]
    public class NirvoyClient : Auditable
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ClientId { get; set; }
        [Required(ErrorMessage = "Name is required.")]
        [MaxLength(150, ErrorMessage = "Name can be max 150 characters long.")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Mobile Number is required.")]
        [MinLength(11, ErrorMessage = "Mobile Number must be at least 11 characters long.")]
        [MaxLength(14, ErrorMessage = "Mobile Number can be max 14 characters long.")]
        [DataType(DataType.PhoneNumber, ErrorMessage = "Please enter a valid Mobule Number.")]
        public string MobileNumber { get; set; }
        [Range(1, 99, ErrorMessage = "Age must be a number between 1 and 99.")]
        public int Age { get; set; }
        [MaxLength(30, ErrorMessage = "Identification Type can be max 30 characters long.")]
        public string PersonalIdType { get; set; }
        [MaxLength(50, ErrorMessage = "Identification Number can be max 50 characters long.")]
        public string PersonalId { get; set; }
        [Required(ErrorMessage = "Nominee Name is required.")]
        [MaxLength(150, ErrorMessage = "Nominee Name can be max 150 characters long.")]
        public string BeneName { get; set; }
        [MinLength(11, ErrorMessage = "Nominee Mobile Number must be at least 11 characters long.")]
        [MaxLength(14, ErrorMessage = "Nominee Mobile Number can be max 14 characters long.")]
        [DataType(DataType.PhoneNumber, ErrorMessage = "Please enter a valid Nominee Mobule Number.")]
        public string BeneMobileNumber { get; set; }
        [Range(0, 99, ErrorMessage = "Nominee Age must be a number between 0 and 99.")]
        public int? BeneAge { get; set; }
        [Required(ErrorMessage = "Relationship is required.")]
        [MaxLength(50, ErrorMessage = "Relationship can be max 50 characters long.")]
        public string BeneRelationship { get; set; }
        public decimal? LoanAmount { get; set; }
        [Required(ErrorMessage = "SIM card Owner is required.")]
        [MaxLength(50, ErrorMessage = "SIM card Owner can be max 50 characters long.")]
        public string DeviceOwnership { get; set; }
        [Required(ErrorMessage = "Terms and Conditions is required.")]
        [Compare(nameof(IsTrue), ErrorMessage = "Please agree to Terms and Conditions")]
        public bool AcceptsTerms { get; set; }
        public bool ThirdPartyAuthorized { get; set; } = true;

        [Required(ErrorMessage = "Subscription Channel is required.")]
        public string SubscriptionChannel { get; set; }
        [MinLength(11, ErrorMessage = "Agent Mobile Number must be at least 11 characters long.")]
        [MaxLength(14, ErrorMessage = "Agent Mobile Number can be max 14 characters long.")]
        [DataType(DataType.PhoneNumber, ErrorMessage = "Please enter a valid Agent Mobule Number.")]
        public string AgentMobileNumber { get; set; }
        [Required(ErrorMessage = "Entry Source is required.")]
        public string EntrySource { get; set; }
        [Required(ErrorMessage = "Status is required.")]
        public string Status { get; set; }
        [NotMapped]
        public bool IsTrue => true;

    }
}