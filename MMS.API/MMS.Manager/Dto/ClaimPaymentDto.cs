using MMS.Core;
using MMS.DAL;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
	[AutoMap(typeof(ClaimPayment)), Serializable]
	public class ClaimPaymentDto : Auditable
	{

		private int paymentId;
		public int PaymentId 
		{
			get
			{
				return paymentId;
			}
			set
			{
				if (PropertyChanged(paymentId, value))
					paymentId = value;
			}
		}

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

		private string paymentMethod;
		public string PaymentMethod 
		{
			get
			{
				return paymentMethod;
			}
			set
			{
				if (PropertyChanged(paymentMethod, value))
					paymentMethod = value;
			}
		}

		private string payeeType;
		public string PayeeType 
		{
			get
			{
				return payeeType;
			}
			set
			{
				if (PropertyChanged(payeeType, value))
					payeeType = value;
			}
		}

        private int? payeeId;
        public int? PayeeId
        {
            get
            {
                return payeeId;
            }
            set
            {
                if (PropertyChanged(payeeId, value))
                    payeeId = value;
            }
        }

        private string payeeName;
		public string PayeeName 
		{
			get
			{
				return payeeName;
			}
			set
			{
				if (PropertyChanged(payeeName, value))
					payeeName = value;
			}
		}

        private decimal amount;
        public decimal Amount
        {
            get
            {
                return amount;
            }
            set
            {
                if (PropertyChanged(amount, value))
                    amount = value;
            }
        }

        private DateTime? issuedDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? IssuedDate 
		{
			get
			{
				return issuedDate;
			}
			set
			{
				if (PropertyChanged(issuedDate, value))
					issuedDate = value;
			}
		}

		private string issuedBy;
		public string IssuedBy 
		{
			get
			{
				return issuedBy;
			}
			set
			{
				if (PropertyChanged(issuedBy, value))
					issuedBy = value;
			}
		}

		private DateTime? receivedPayeeDate;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? ReceivedPayeeDate 
		{
			get
			{
				return receivedPayeeDate;
			}
			set
			{
				if (PropertyChanged(receivedPayeeDate, value))
					receivedPayeeDate = value;
			}
		}

		private string payeeComment;
		public string PayeeComment 
		{
			get
			{
				return payeeComment;
			}
			set
			{
				if (PropertyChanged(payeeComment, value))
					payeeComment = value;
			}
		}

		private string nameOnCheque;
		public string NameOnCheque 
		{
			get
			{
				return nameOnCheque;
			}
			set
			{
				if (PropertyChanged(nameOnCheque, value))
					nameOnCheque = value;
			}
		}

		private string chequeNumber;
		public string ChequeNumber 
		{
			get
			{
				return chequeNumber;
			}
			set
			{
				if (PropertyChanged(chequeNumber, value))
					chequeNumber = value;
			}
		}

		private string chequeAddress;
		public string ChequeAddress 
		{
			get
			{
				return chequeAddress;
			}
			set
			{
				if (PropertyChanged(chequeAddress, value))
					chequeAddress = value;
			}
		}

		private DateTime? dateOnCheque;
		[JsonConverter(typeof(DateConverter))]
		public DateTime? DateOnCheque 
		{
			get
			{
				return dateOnCheque;
			}
			set
			{
				if (PropertyChanged(dateOnCheque, value))
					dateOnCheque = value;
			}
		}

		private string accountName;
		public string AccountName 
		{
			get
			{
				return accountName;
			}
			set
			{
				if (PropertyChanged(accountName, value))
					accountName = value;
			}
		}

		private string accountNumber;
		public string AccountNumber 
		{
			get
			{
				return accountNumber;
			}
			set
			{
				if (PropertyChanged(accountNumber, value))
					accountNumber = value;
			}
		}

		private string sendingBank;
		public string SendingBank 
		{
			get
			{
				return sendingBank;
			}
			set
			{
				if (PropertyChanged(sendingBank, value))
					sendingBank = value;
			}
		}

		private string receivingBank;
		public string ReceivingBank 
		{
			get
			{
				return receivingBank;
			}
			set
			{
				if (PropertyChanged(receivingBank, value))
					receivingBank = value;
			}
		}

		private string transactionRef;
		public string TransactionRef 
		{
			get
			{
				return transactionRef;
			}
			set
			{
				if (PropertyChanged(transactionRef, value))
					transactionRef = value;
			}
		}

		private string bankIdentificationNumber;
		public string BankIdentificationNumber 
		{
			get
			{
				return bankIdentificationNumber;
			}
			set
			{
				if (PropertyChanged(bankIdentificationNumber, value))
					bankIdentificationNumber = value;
			}
		}

		private string walletName;
		public string WalletName 
		{
			get
			{
				return walletName;
			}
			set
			{
				if (PropertyChanged(walletName, value))
					walletName = value;
			}
		}

		private string walletNumber;
		public string WalletNumber 
		{
			get
			{
				return walletNumber;
			}
			set
			{
				if (PropertyChanged(walletNumber, value))
					walletNumber = value;
			}
		}

        private bool? voidPayment;
        public bool? VoidPayment
        {
            get
            {
                return voidPayment;
            }
            set
            {
                if (PropertyChanged(voidPayment, value))
                    voidPayment = value;
            }
        }

    }
}