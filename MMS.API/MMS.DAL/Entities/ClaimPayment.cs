using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("ClaimPayment")]
	public class ClaimPayment : Auditable
	{
		[Key]
		public int PaymentId { get; set; }
		
		public int ClaimId { get; set; }
		[Required]
		public string PaymentMethod { get; set; }
		[Required]
		public string PayeeType { get; set; }
        public int? PayeeId { get; set; }
        public string PayeeName { get; set; }
        public decimal Amount { get; set; }
        [Column(TypeName = "date")]
		public DateTime? IssuedDate { get; set; }
		
		public string IssuedBy { get; set; }
		[Column(TypeName = "date")]
		public DateTime? ReceivedPayeeDate { get; set; }
		
		public string PayeeComment { get; set; }
		
		public string NameOnCheque { get; set; }
		
		public string ChequeNumber { get; set; }
		
		public string ChequeAddress { get; set; }
		[Column(TypeName = "date")]
		public DateTime? DateOnCheque { get; set; }
		
		public string AccountName { get; set; }
		
		public string AccountNumber { get; set; }
		
		public string SendingBank { get; set; }
		
		public string ReceivingBank { get; set; }
		
		public string TransactionRef { get; set; }
		
		public string BankIdentificationNumber { get; set; }
		
		public string WalletName { get; set; }
		
		public string WalletNumber { get; set; }

        public bool? VoidPayment { get; set; }

    }
}