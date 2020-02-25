using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Core;
using MMS.Manager;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [Authorize, ApiController, Route("Api/[action]")]
    public class IntegrationController : BaseController
    {
        readonly IPolicyManager Manager;
        public IntegrationController(IPolicyManager manager)
        {
            Manager = manager;
        }

        // GET: /Api/GetProducts
        [HttpGet]
        public async Task<ActionResult> GetProducts()
        {
            var list = await Manager.GetProducts(AppContexts.User.PartnerId);
            return OkResult(list);
        }

        // GET: /Api/GetBenefits
        [HttpGet]
        public async Task<ActionResult> GetBenefits()
        {
            var list = await Manager.GetBenefits(AppContexts.User.ProductId);
            return OkResult(list);
        }

        // GET: /Api/GetAssetTypes
        [HttpGet]
        public async Task<ActionResult> GetAssetTypes()
        {
            var list = await Manager.GetConfigurations("AssetType");
            return OkResult(list);
        }

        // GET: /Api/GetBusinessDescriptions
        [HttpGet]
        public async Task<ActionResult> GetBusinessDescriptions()
        {
            var list = await Manager.GetProductConfigurations(AppContexts.User.ProductId, "BusinessDescription");
            return OkResult(list);
        }

        // POST: /Api/CreatePolicy
        [HttpPost]
        public async Task<IActionResult> CreatePolicy([FromBody]PolicySave policy)
        {
            if (policy.IsNull() || policy.Policy.IsNull()) return ValidationResult($"Invalid data.");
            var isUsed = await Manager.UseExternal(policy.Policy.ExternalId);
            if (isUsed) return ValidationResult($"An active policy already exists for this External Id.");
            if (policy.Policy.PartnerId.IsZero()) policy.Policy.PartnerId = AppContexts.User.PartnerId;
            if (policy.Policy.ProductId.IsZero()) policy.Policy.ProductId = AppContexts.User.ProductId;
            var benefit = await Manager.GetBenefit(policy.Policy.ProductId, policy.Policy.BenefitId);
            if (benefit.CoverageType != "Asset") policy.Asset = new PolicyAssetDto();
            await Manager.Create(policy);
            return CreatedResult(new { policy.Policy.PolicyNumber, policy.Policy.PolicyStatus });
        }

    }
}
