using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("Client")]
	public class Client : Auditable
	{
		[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]
		public int ClientId { get; set; }
        [Required(ErrorMessage = "Client type is required.")]
        public string ClientType { get; set; }
        [Required(ErrorMessage = "Relationship is required.")]
        public string Relationship { get; set; }
		
		public int? AgeAtCreationDate { get; set; }
        [Required(ErrorMessage = "First name is required.")]
        [MaxLength(100, ErrorMessage = "First name can be max 100 characters long.")]
        public string FirstName { get; set; }

        [MaxLength(100, ErrorMessage = "Last name can be max 100 characters long.")]
        public string LastName { get; set; }

        [MinLength(11, ErrorMessage = "Mobile no must be at least 11 characters long.")]
        [MaxLength(14, ErrorMessage = "Mobile no can be max 14 characters long.")]
        [DataType(DataType.PhoneNumber, ErrorMessage = "Please enter a valid Mobule Number.")]
        public string MobileNo { get; set; }
		
		public string AccountNo { get; set; }
		[Column(TypeName = "date")]
		public DateTime? DateofBirth { get; set; }
		
		public string Gender { get; set; }
		
		public string MaritalStatus { get; set; }
        [MaxLength(30, ErrorMessage = "Personal Id Type can be max 30 characters long.")]

        public string PersonalIdType { get; set; }

        [MaxLength(50, ErrorMessage = "Personal Id can be max 50 characters long.")]
        public string PersonalId { get; set; }
		
		public string Address { get; set; }
		
		public string Email { get; set; }
		
		public string Location { get; set; }
		
		public string Language { get; set; }
		
		public string PostalCode { get; set; }
		
		public string Communication { get; set; }

	}
}