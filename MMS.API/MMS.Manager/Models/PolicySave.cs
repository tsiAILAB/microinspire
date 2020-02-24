using System.Collections.Generic;

namespace MMS.Manager
{
    public class PolicySave
    {
        public PolicyDto Policy { get; set; }
        public PolicyAssetDto Asset { get; set; }
        public List<ClientDto> Clients { get; set; }
        public List<PolicyNoteDto> Notes { get; set; }
        public List<Dictionary<string, object>> Claims { get; set; }

    }
}
