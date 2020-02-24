using AspNetCore.Reporting;
using MMS.Core;
using MMS.DAL;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public class ReportManager : IReportManager
    {
        readonly IModelAdapter Adapter;
        public ReportManager(IModelAdapter adapter)
        {
            Adapter = adapter;
        }

        public async Task<List<Dictionary<string, object>>> GetSpFields(string procedure)
        {
            return await Adapter.GetSpFields(procedure);
        }

        public async Task<byte[]> RenderClient(ReportModel parameter, string reportName)
        {
            var source = await Adapter.GetReportSource("RPTClient  @0, @1, @2, @3, @4, @5, @6",
                parameter.UserId, parameter.PartnerId, parameter.ProductId, parameter.NonInsured, parameter.Criteria, parameter.FromDate.Value(), parameter.ToDate.Value());
            return Render(source.Tables[0], parameter.Fields, reportName);
        }

        public async Task<byte[]> RenderCover(ReportModel parameter, string reportName)
        {
            var source = await Adapter.GetReportSource("RPTCover  @0, @1, @2, @3, @4, @5",
                parameter.UserId, parameter.PartnerId, parameter.ProductId, parameter.Criteria, parameter.FromDate.Value(), parameter.ToDate.Value());
            return Render(source.Tables[0], parameter.Fields, reportName);
        }

        public async Task<byte[]> RenderPayment(ReportModel parameter, string reportName)
        {
            var source = await Adapter.GetReportSource("RPTPayment  @0, @1, @2, @3, @4, @5, @6",
                parameter.UserId, parameter.PartnerId, parameter.ProductId, parameter.Status, parameter.Criteria, parameter.FromDate.Value(), parameter.ToDate.Value());
            return Render(source.Tables[0], parameter.Fields, reportName);
        }

        public async Task<byte[]> RenderPolicy(ReportModel parameter, string reportName)
        {
            var source = await Adapter.GetReportSource("RPTPolicy  @0, @1, @2, @3, @4, @5",
                parameter.UserId, parameter.PartnerId, parameter.ProductId, parameter.Criteria, parameter.FromDate.Value(), parameter.ToDate.Value());
            return Render(source.Tables[0], parameter.Fields, reportName);
        }

        public async Task<byte[]> RenderClaimDetails(ReportModel parameter, string reportName)
        {
            var source = await Adapter.GetReportSource("RPTClaimDetails  @0, @1, @2, @3, @4, @5",
                parameter.UserId, parameter.PartnerId, parameter.ProductId, parameter.Status, parameter.FromDate.Value(), parameter.ToDate.Value());
            return Render(source.Tables[0], parameter.Fields, reportName);
        }

        public async Task<byte[]> RenderClaimPayments(ReportModel parameter, string reportName)
        {
            var source = await Adapter.GetReportSource("RPTClaimPayments  @0, @1, @2, @3, @4",
                parameter.UserId, parameter.PartnerId, parameter.ProductId, parameter.FromDate.Value(), parameter.ToDate.Value());
            return Render(source.Tables[0], parameter.Fields, reportName);
        }

        public async Task<byte[]> RenderCWT(ReportModel parameter, string reportName)
        {
            var source = await Adapter.GetReportSource("RPTCWT  @0, @1, @2",
                parameter.UserId, parameter.PartnerId, parameter.ProductId);
            return Render(source.Tables[0], parameter.Fields, reportName);
        }

        public async Task<byte[]> RenderPartner(ReportModel parameter, string reportName)
        {
            var source = await Adapter.GetReportSource("RPTPartner  @0, @1, @2, @3, @4, @5, @6, @7",
                parameter.UserId, parameter.PartnerId, parameter.ProductId, parameter.BenefitId, parameter.SalesReference, parameter.Criteria, parameter.FromDate.Value(), parameter.ToDate.Value());
            return Render(source.Tables[0], parameter.Fields, reportName);
        }

        private byte[] Render(DataTable source, List<string> fields, string reportName)
        {
            CreateRDL(reportName, source.Columns, fields);
            var localReport = new LocalReport(reportName);
            localReport.AddDataSource("ExportReport", source);
            var result = localReport.Execute(RenderType.Excel);
            return result.MainStream;
        }

        private void CreateRDL(string fileName, DataColumnCollection columns, List<string> hideCols = null)
        {
            var fields = RDLGenerator.GetFields(columns, hideCols);
            var report = RDLGenerator.GenerateRdl("ExportReport", fields);
            report.Save(fileName);
        }

        private byte[] ToCSV(DataTable table)
        {
            var result = new StringBuilder();
            for (var i = 0; i < table.Columns.Count; i++)
            {
                result.Append(table.Columns[i].ColumnName);
                result.Append(i == table.Columns.Count - 1 ? "\n" : ",");
            }
            foreach (DataRow row in table.Rows)
            {
                for (var i = 0; i < table.Columns.Count; i++)
                {
                    result.Append(row[i]);
                    result.Append(i == table.Columns.Count - 1 ? "\n" : ",");
                }
            }
            return Encoding.GetEncoding("iso-8859-1").GetBytes(result.ToString());
        }
    }
}