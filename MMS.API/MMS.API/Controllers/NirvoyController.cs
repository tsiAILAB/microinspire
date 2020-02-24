using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MMS.Manager;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [Authorize, ApiController, Route("[controller]/[action]")]
    public class NirvoyController : BaseController
    {
        readonly INirvoyManager Manager;
        public NirvoyController(INirvoyManager manager)
        {
            Manager = manager;
        }
        // POST: /Nirvoy/Enroll
        [HttpPost]
        public async Task<IActionResult> Enroll([FromBody]NirvoyClientDto client)
        {
            var isUsed = await Manager.UseMobileNumber(client.MobileNumber);
            if (isUsed) return ValidationResult($"Mobile Number is Already Registered.");
            await Manager.Create(client);
            return CreatedResult();
        }
        // GET: /Nirvoy/GetNirvoyClient
        [HttpGet]
        public async Task<IActionResult> GetNirvoyClient(string mobileNumber)
        {
            var client = await Manager.GetNirvoyClient(mobileNumber);
            return OkResult(client);
        }
    }
}
