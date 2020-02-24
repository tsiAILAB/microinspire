using System.Collections.Generic;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public interface IReportManager
    {
        Task<List<Dictionary<string, object>>> GetSpFields(string procedure);
        Task<byte[]> RenderClient(ReportModel parameter, string reportName);
        Task<byte[]> RenderCover(ReportModel parameter, string reportName);
        Task<byte[]> RenderPayment(ReportModel parameter, string reportName);
        Task<byte[]> RenderPolicy(ReportModel parameter, string reportName);
        Task<byte[]> RenderClaimDetails(ReportModel parameter, string reportName);
        Task<byte[]> RenderClaimPayments(ReportModel parameter, string reportName);
        Task<byte[]> RenderCWT(ReportModel parameter, string reportName);
        Task<byte[]> RenderPartner(ReportModel parameter, string reportName);
    }
}