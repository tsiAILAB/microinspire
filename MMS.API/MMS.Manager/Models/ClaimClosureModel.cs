using Core;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
    public class ClaimClosureModel
    {        
        public int ClaimId { get; set; }
        public string ClosureReason { get; set; }
        [JsonConverter(typeof(DateConverter))]
        public DateTime? ClosureDate { get; set; }
        public string ClaimStatus { get; set; }
        public ClaimNoteDto Note { get; set; }
    }
}
