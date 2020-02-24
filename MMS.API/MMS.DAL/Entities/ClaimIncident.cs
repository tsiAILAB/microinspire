using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MMS.DAL
{
	[Table("ClaimIncident")]
	public class ClaimIncident : Auditable
	{
		[Key]
		public int IncidentId { get; set; }
		
		public int ClaimId { get; set; }
		[Column(TypeName = "date")]
		public DateTime DateOfDeath { get; set; }
		
		public string LocationOfIncident { get; set; }
		
		public string IncidentType { get; set; }
		
		public int? DaysFromIncident { get; set; }
		
		public string HospitalName { get; set; }
		
		public string HospitalWard { get; set; }
		
		public string HospitalLocation { get; set; }
		
		public string CauseOfIncident { get; set; }
		
		public string Note { get; set; }

	}
}