using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MMS.Manager;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [Authorize, ApiController, Route("[controller]/[action]")]
    public class ComboController : BaseController
    {
        readonly IComboManager Manager;

        public ComboController(IComboManager manager)
        {
            Manager = manager;
        }

        // GET: /Combo/GetConfigurations/{configType}
        [HttpGet("{configType}")]
        public async Task<ActionResult> GetConfigurations(string configType)
        {
            var list = await Manager.GetConfigurations(configType);
            return Ok(list);
        }
        // GET: /Combo/GetProductConfigurations/{productId}/{configType}
        [HttpGet("{productId}/{configType}")]
        public async Task<ActionResult> GetProductConfigurations(int productId, string configType)
        {
            var list = await Manager.GetProductConfigurations(productId, configType);
            return Ok(list);
        }
        // GET: /Combo/GetCountries
        [HttpGet]
        public async Task<ActionResult> GetCountries()
        {
            var list = await Manager.GetCountries();
            return Ok(list);
        }
        // GET: /Combo/GetAllPartners
        [HttpGet]
        public async Task<ActionResult> GetAllPartners()
        {
            var list = await Manager.GetAllPartners();
            return Ok(list);
        }
        // GET: /Combo/GetPartners
        [HttpGet]
        public async Task<ActionResult> GetPartners()
        {
            var list = await Manager.GetPartners();
            return Ok(list);
        }
        // GET: /Combo/GetPartners/{countryId}
        [HttpGet("{countryId:int}")]
        public async Task<ActionResult> GetPartners(int countryId)
        {
            var list = await Manager.GetPartners(countryId);
            return Ok(list);
        }
        // GET: /Combo/GetProducts/{partnerId}
        [HttpGet("{partnerId:int}")]
        public async Task<ActionResult> GetProducts(int partnerId)
        {
            var list = await Manager.GetProducts(partnerId);
            return Ok(list);
        }
        // GET: /Combo/GetBenefits
        [HttpGet]
        public async Task<ActionResult> GetBenefits()
        {
            var list = await Manager.GetBenefits();
            return Ok(list);
        }
        // GET: /Combo/GetBenefits/{productId}
        [HttpGet("{productId:int}")]
        public async Task<ActionResult> GetBenefits(int productId)
        {
            var list = await Manager.GetBenefits(productId);
            return Ok(list);
        }
        // GET: /Combo/GetBenefitsByProduct/{productId}
        [HttpGet("{productId:int}")]
        public async Task<ActionResult> GetBenefitsByProduct(int productId)
        {
            var list = await Manager.GetBenefitsByProduct(productId);
            return Ok(list);
        }
        // GET: /Combo/GetBusiness/{productId}
        [HttpGet("{productId:int}")]
        public async Task<ActionResult> GetBusiness(int productId)
        {
            var list = await Manager.GetBusiness(productId);
            return Ok(list);
        }
        // GET: /Combo/GetUnderWriters
        [HttpGet]
        public async Task<ActionResult> GetUnderWriters()
        {
            var list = await Manager.GetUnderWriters();
            return Ok(list);
        }
    }
}
