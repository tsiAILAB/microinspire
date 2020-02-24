using MMS.DAL;
using System;

namespace MMS.Manager
{
    [AutoMap(typeof(ClaimNote)), Serializable]
	public class ClaimNoteDto : Auditable
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