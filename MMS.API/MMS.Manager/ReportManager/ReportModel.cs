using MMS.Core;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace MMS.Manager
{
    public class ReportModel
    {
        public string ReportName { get; set; }

        public int UserId { get; set; }

        public int CountryId { get; set; }

        public int PartnerId { get; set; }
		
		public int ProductId { get; set; }

        public int BenefitId { get; set; }        

        public string Criteria { get; set; }

        public string Status { get; set; }

        public string SalesReference { get; set; }

        public string NonInsured { get; set; }

        [JsonConverter(typeof(DateConverter))]
        public DateTime? FromDate { get; set; }
        [JsonConverter(typeof(DateConverter))]
        public DateTime? ToDate { get; set; }

        public List<string> Fields { get; set; }
    }
}