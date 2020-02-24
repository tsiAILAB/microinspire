namespace MMS.Manager
{
	public class ClaimSearch
	{
		public string ClaimNumber { get; set; }
		
		public int PartnerId { get; set; }
		
		public int ProductId { get; set; }
		
		public int BusinessId { get; set; }

        public string PolicyNumber { get; set; }
		
		public string InsuredFirstName { get; set; }
		
		public string InsuredLastName { get; set; }
		
		public string ExternalId { get; set; }
		
		public string NotifierLocation { get; set; }

        public string ClaimStatus { get; set; }

        public bool? ConfirmationRequired { get; set; }

    }
}