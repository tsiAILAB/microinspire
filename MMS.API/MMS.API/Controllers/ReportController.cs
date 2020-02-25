using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Core;
using MMS.Manager;
using System;
using System.IO;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [Authorize, ApiController, Route("[controller]/[action]")]
    public class ReportController : BaseController
    {
        readonly IMemoryCache Cache;
        readonly IHostingEnvironment Env;
        readonly IReportManager Manager;
        public ReportController(IHostingEnvironment env, IMemoryCache cache, IReportManager manager)
        {
            Env = env;
            Cache = cache;
            Manager = manager;
        }
        // GET: /Report/GetSpFields/{procedure}
        [HttpGet("{procedure}")]
        public async Task<IActionResult> GetSpFields(string procedure)
        {
            var fields = await Manager.GetSpFields(procedure);
            return OkResult(fields);
        }
        // POST: /Report/InitParameter
        [HttpPost]
        public async Task<IActionResult> InitParameter([FromBody]ReportModel model)
        {
            var cacheKey = CreateCache(model);
            return await Task.FromResult(OkResult(cacheKey));
        }
        // GET: /Report/ShowClient/{cacheKey}
        [AllowAnonymous, HttpGet("{cacheKey}")]
        public async Task<IActionResult> ShowClient(string cacheKey)
        {
            var parameter = GetCache(cacheKey);
            if (parameter.IsNull()) throw new ArgumentNullException("ShowClient");
            var fileName = Path.Combine(Env.ContentRootPath, "wwwroot\\Reports", $"{Guid.NewGuid()}.rdl");
            var reportBytes = await Manager.RenderClient(parameter, fileName);
            DeleteTempFile(fileName);
            return ReturnFile(reportBytes, $"{parameter.ReportName}.xls");
        }
        // GET: /Report/ShowCover/{cacheKey}
        [AllowAnonymous, HttpGet("{cacheKey}")]
        public async Task<IActionResult> ShowCover(string cacheKey)
        {
            var parameter = GetCache(cacheKey);
            if (parameter.IsNull()) throw new ArgumentNullException("ShowCover");
            var fileName = Path.Combine(Env.ContentRootPath, "wwwroot\\Reports", $"{Guid.NewGuid()}.rdl");
            var reportBytes = await Manager.RenderCover(parameter, fileName);
            DeleteTempFile(fileName);
            return ReturnFile(reportBytes, $"{parameter.ReportName}.xls");
        }
        // GET: /Report/ShowPayment/{cacheKey}
        [AllowAnonymous, HttpGet("{cacheKey}")]
        public async Task<IActionResult> ShowPayment(string cacheKey)
        {
            var parameter = GetCache(cacheKey);
            if (parameter.IsNull()) throw new ArgumentNullException("ShowPayment");
            var fileName = Path.Combine(Env.ContentRootPath, "wwwroot\\Reports", $"{Guid.NewGuid()}.rdl");
            var reportBytes = await Manager.RenderPayment(parameter, fileName);
            DeleteTempFile(fileName);
            return ReturnFile(reportBytes, $"{parameter.ReportName}.xls");
        }
        // GET: /Report/ShowPolicy/{cacheKey}
        [AllowAnonymous, HttpGet("{cacheKey}")]
        public async Task<IActionResult> ShowPolicy(string cacheKey)
        {
            var parameter = GetCache(cacheKey);
            if (parameter.IsNull()) throw new ArgumentNullException("ShowPolicy");
            var fileName = Path.Combine(Env.ContentRootPath, "wwwroot\\Reports", $"{Guid.NewGuid()}.rdl");
            var reportBytes = await Manager.RenderPolicy(parameter, fileName);
            DeleteTempFile(fileName);
            return ReturnFile(reportBytes, $"{parameter.ReportName}.xls");
        }
        // GET: /Report/ShowClaimDetails/{cacheKey}
        [AllowAnonymous, HttpGet("{cacheKey}")]
        public async Task<IActionResult> ShowClaimDetails(string cacheKey)
        {
            var parameter = GetCache(cacheKey);
            if (parameter.IsNull()) throw new ArgumentNullException("ShowClaimDetails");
            var fileName = Path.Combine(Env.ContentRootPath, "wwwroot\\Reports", $"{Guid.NewGuid()}.rdl");
            var reportBytes = await Manager.RenderClaimDetails(parameter, fileName);
            DeleteTempFile(fileName);
            return ReturnFile(reportBytes, $"{parameter.ReportName}.xls");
        }
        // GET: /Report/ShowClaimPayments/{cacheKey}
        [AllowAnonymous, HttpGet("{cacheKey}")]
        public async Task<IActionResult> ShowClaimPayments(string cacheKey)
        {
            var parameter = GetCache(cacheKey);
            if (parameter.IsNull()) throw new ArgumentNullException("ShowClaimPayments");
            var fileName = Path.Combine(Env.ContentRootPath, "wwwroot\\Reports", $"{Guid.NewGuid()}.rdl");
            var reportBytes = await Manager.RenderClaimPayments(parameter, fileName);
            DeleteTempFile(fileName);
            return ReturnFile(reportBytes, $"{parameter.ReportName}.xls");
        }
        // GET: /Report/ShowCWT/{cacheKey}
        [AllowAnonymous, HttpGet("{cacheKey}")]
        public async Task<IActionResult> ShowCWT(string cacheKey)
        {
            var parameter = GetCache(cacheKey);
            if (parameter.IsNull()) throw new ArgumentNullException("ShowCWT");
            var fileName = Path.Combine(Env.ContentRootPath, "wwwroot\\Reports", $"{Guid.NewGuid()}.rdl");
            var reportBytes = await Manager.RenderCWT(parameter, fileName);
            DeleteTempFile(fileName);
            return ReturnFile(reportBytes, $"{parameter.ReportName}.xls");
        }
        // GET: /Report/ShowPartner/{cacheKey}
        [AllowAnonymous, HttpGet("{cacheKey}")]
        public async Task<IActionResult> ShowPartner(string cacheKey)
        {
            var parameter = GetCache(cacheKey);
            if (parameter.IsNull()) throw new ArgumentNullException("ShowPartner");
            var fileName = Path.Combine(Env.ContentRootPath, "wwwroot\\Reports", $"{Guid.NewGuid()}.rdl");
            var reportBytes = await Manager.RenderPartner(parameter, fileName);
            DeleteTempFile(fileName);
            return ReturnFile(reportBytes, $"{parameter.ReportName}.xls");
        }
        private IActionResult ReturnFile(byte[] reportBytes, string fileName)
        {
            //application/vnd.ms-excel
            //application/pdf
            //text/csv
            var reportStream = new MemoryStream(reportBytes);
            return File(reportStream, "application/vnd.ms-excel", fileName);
        }
        private string CreateCache(ReportModel model)
        {
            var cacheKey = Guid.NewGuid().ToString();
            var cacheEntryOptions = new MemoryCacheEntryOptions()
            .SetSlidingExpiration(TimeSpan.FromMinutes(1));
            model.UserId = AppContexts.User.UserId;
            Cache.Set(cacheKey, model, cacheEntryOptions);
            return cacheKey;
        }
        private ReportModel GetCache(string cacheKey)
        {
            if (!Cache.TryGetValue(cacheKey, out ReportModel parameter))
                return null;
            else
            {
                Cache.Remove(cacheKey);
                return parameter;
            }
        }
        private void DeleteTempFile(string fileName)
        {
            try
            {
                System.IO.File.Delete(fileName);
            }
            catch { }
        }
    }
}
