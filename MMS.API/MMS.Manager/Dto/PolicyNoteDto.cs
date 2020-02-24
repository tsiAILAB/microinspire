using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(PolicyNote)), Serializable]
	public class PolicyNoteDto : Auditable
	{

		private int noteId;
		public int NoteId 
		{
			get
			{
				return noteId;
			}
			set
			{
				if (PropertyChanged(noteId, value))
					noteId = value;
			}
		}

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

		private string note;
		public string Note 
		{
			get
			{
				return note;
			}
			set
			{
				if (PropertyChanged(note, value))
					note = value;
			}
		}

        public string CreatedByName { get; set; }
        public string CreatedAtDate { get; set; }

    }
}