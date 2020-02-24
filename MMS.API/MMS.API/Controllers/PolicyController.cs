using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MMS.Core;
using MMS.Manager;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [Authorize, ApiController, Route("[controller]/[action]")]
    public class PolicyController : BaseController
    {
        readonly IPolicyManager Manager;
        public PolicyController(IPolicyManager manager)
        {
            Manager = manager;
        }
        // GET: /Policy/GetPolicy/{policyId}
        [HttpGet("{policyId:int}")]
        public async Task<IActionResult> GetPolicy(int policyId)
        {
            if (policyId.LessThen(1)) return ValidationResult("Policy Id can't less then 1.");
            var policy = await Manager.GetPolicy(policyId);
            if (policy.IsNull()) return NotFoundResult($"Policy with id '{policyId}' not found.");
            return OkResult(policy);
        }
        // GET: /Policy/GetNotifier/{policyId}/{clientType}
        [HttpGet("{policyId}/{clientType}")]
        public async Task<IActionResult> GetNotifier(int policyId, string clientType)
        {
            var policy = await Manager.GetNotifier(policyId, clientType);
            return OkResult(policy);
        }
        // GET: /Policy/UseExternal/{externalId}
        [HttpGet("{externalId}")]
        public async Task<IActionResult> UseExternal(string externalId)
        {
            var isUsed = await Manager.UseExternal(externalId);
            if (isUsed) return ValidationResult($"An active policy already exists for this External Id.");
            return OkResult();
        }
        // GET: /Policy/GetPolicyByExternal/{externalId}
        [HttpGet("{externalId}")]
        public async Task<IActionResult> GetPolicyByExternal(string externalId)
        {
            var policy = await Manager.GetPolicyByExternal(externalId);
            return OkResult(policy);
        }
        // POST: /Policy/Create
        [HttpPost]
        public async Task<IActionResult> Create([FromBody]PolicySave policy)
        {
            var isUsed = await Manager.UseExternal(policy.Policy.ExternalId);
            if (isUsed) return ValidationResult($"An active policy already exists for this External Id.");
            await Manager.Create(policy);
            return CreatedResult(policy.Policy);
        }
        // POST: /Policy/Search
        [HttpPost]
        public async Task<IActionResult> Search([FromBody]PolicySearch search)
        {
            var policies = await Manager.GetPolicies(search);
            return OkResult(policies);
        }
        // POST: /Policy/SaveClient
        [HttpPost]
        public async Task<IActionResult> SaveClient([FromBody]ClientDto client)
        {
            if (client.PolicyId.LessThen(1)) return ValidationResult("Policy Id can't less then 1.");
            if (client.ClientId.IsZero())
                client.SetAdded();
            else client.SetModified();
            client = await Manager.SaveClient(client);
            return CreatedResult(client);
        }
        // POST: /Policy/CreateNote
        [HttpPost]
        public async Task<IActionResult> CreateNote([FromBody]PolicyNoteDto note)
        {
            if (note.PolicyId.LessThen(1)) return ValidationResult("Policy Id can't less then 1.");
            if (note.Note.IsNullOrEmpty()) return ValidationResult("Policy note can't be empty");
            note.SetAdded();
            note = await Manager.CreateNote(note);
            return CreatedResult(note);
        }
        // POST: /Policy/EndPolicy
        [HttpPost]
        public async Task<ActionResult> EndPolicy(PolicyEndModel policyEnd)
        {
            if (policyEnd.PolicyId.LessThen(1)) return ValidationResult("Policy Id can't less then 1.");
            await Manager.EndPolicy(policyEnd);
            return OkResult(policyEnd);
        }
        // GET: /Policy/GetDashboard
        [HttpGet()]
        public async Task<IActionResult> GetDashboard()
        {
            var info = await Manager.GetDashboard();
            return OkResult(info);
        }
    }
}
