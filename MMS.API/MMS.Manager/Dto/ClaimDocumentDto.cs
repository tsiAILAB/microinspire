using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(ClaimDocument)), Serializable]
	public class ClaimDocumentDto : Auditable
	{

		private int documentId;
		public int DocumentId 
		{
			get
			{
				return documentId;
			}
			set
			{
				if (PropertyChanged(documentId, value))
					documentId = value;
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

		private string documentType;
		public string DocumentType 
		{
			get
			{
				return documentType;
			}
			set
			{
				if (PropertyChanged(documentType, value))
					documentType = value;
			}
		}

		private string filePath;
		public string FilePath 
		{
			get
			{
				return filePath;
			}
			set
			{
				if (PropertyChanged(filePath, value))
					filePath = value;
			}
		}

		private string fileName;
		public string FileName 
		{
			get
			{
				return fileName;
			}
			set
			{
				if (PropertyChanged(fileName, value))
					fileName = value;
			}
		}

        private string orgFileName;
        public string OrgFileName
        {
            get
            {
                return orgFileName;
            }
            set
            {
                if (PropertyChanged(orgFileName, value))
                    orgFileName = value;
            }
        }

        private string comments;
		public string Comments 
		{
			get
			{
				return comments;
			}
			set
			{
				if (PropertyChanged(comments, value))
					comments = value;
			}
		}

        public string ClaimNumber { get; set; }
        public string RootPath { get; set; }
        public string CreatedByName { get; set; }

    }
}