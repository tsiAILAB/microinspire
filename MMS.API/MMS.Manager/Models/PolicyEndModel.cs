using MMS.Core;
using Newtonsoft.Json;
using System;

namespace MMS.Manager
{
    public class PolicyEndModel
    {        
        public int PolicyId { get; set; }
        [JsonConverter(typeof(DateConverter))]
        public DateTime? PolicyEnd { get; set; }

        [JsonConverter(typeof(DateConverter))]
        public DateTime? RequestedEndDate { get; set; }
        public string EndReason { get; set; }        
        public PolicyNoteDto Note { get; set; }
    }
}
