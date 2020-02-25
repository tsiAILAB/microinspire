using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Core;
using MMS.Manager;
using System.IO;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [Authorize, ApiController, Route("[controller]/[action]")]
    public class ClaimController : BaseController
    {
        readonly IClaimManager Manager;
        public ClaimController(IClaimManager manager)
        {
            Manager = manager;
        }
        // GET: /Claim/GetClaim/{claimId}
        [HttpGet("{claimId:int}")]
        public async Task<IActionResult> GetClaim(int claimId)
        {
            if (claimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            var claim = await Manager.GetClaim(claimId);
            if (claim.IsNull()) return NotFoundResult($"Claim with id '{claimId}' not found.");
            return OkResult(claim);
        }
        // GET: /Claim/GetHistory/{claimId}
        [HttpGet("{claimId:int}")]
        public async Task<IActionResult> GetHistory(int claimId)
        {
            if (claimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            var history = await Manager.GetHistory(claimId);
            return OkResult(history);
        }
        // POST: /Claim/CreateClaim
        [HttpPost]
        public async Task<IActionResult> CreateClaim([FromBody]ClaimSave claim)
        {
            await Manager.CreateClaim(claim);
            return CreatedResult(claim);
        }
        // POST: /Claim/Create
        [HttpPost]
        public async Task<IActionResult> Create([FromBody]ClaimDto claim)
        {
            await Manager.Create(claim);
            return CreatedResult(claim);
        }
        // POST: /Claim/Search
        [HttpPost]
        public async Task<IActionResult> Search([FromBody]ClaimSearch search)
        {
            var policies = await Manager.GetClaims(search);
            return OkResult(policies);
        }
        // POST: /Claim/CreateNote
        [HttpPost]
        public async Task<IActionResult> CreateNote([FromBody]ClaimNoteDto note)
        {
            if (note.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            if (note.Note.IsNullOrEmpty()) return ValidationResult("Claim note can't be empty");
            note.SetAdded();
            note = await Manager.CreateNote(note);
            return CreatedResult(note);
        }
        // POST: /Claim/UpdateStatus
        [HttpPost]
        public async Task<ActionResult> UpdateStatus(ClaimClosureModel claimClosure)
        {
            if (claimClosure.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            await Manager.UpdateStatus(claimClosure);
            return OkResult(claimClosure);
        }
        // POST: /Claim/CreateClient
        [HttpPost]
        public async Task<ActionResult> CreateClient(ClientDto client)
        {
            if (client.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            await Manager.CreateClient(client);
            return OkResult(client);
        }
        // POST: /Claim/UpdateCover
        [HttpPost]
        public async Task<ActionResult> UpdateCover(ClaimDto claim)
        {
            if (claim.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            await Manager.UpdateCover(claim);
            return OkResult();
        }
        // POST: /Claim/CreateIncident
        [HttpPost]
        public async Task<ActionResult> CreateIncident(ClaimIncidentDto incident)
        {
            if (incident.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            await Manager.CreateIncident(incident);
            return OkResult(incident);
        }
        // POST: /Claim/CreateDocument
        [HttpPost]
        public async Task<ActionResult> CreateDocument(ClaimDocumentDto document)
        {
            if (document.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            MoveDocument(document);
            await Manager.CreateDocument(document);
            return OkResult(document);
        }
        // POST: /Claim/DocumentComplete
        [HttpPost]
        public async Task<ActionResult> DocumentComplete(ClaimDto claim)
        {
            if (claim.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            await Manager.DocumentComplete(claim);
            return OkResult();
        }
        // POST: /Claim/UpdateClaimReview
        [HttpPost]
        public async Task<ActionResult> UpdateClaimReview(ClaimDto claim)
        {
            if (claim.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            var result = await Manager.UpdateClaimReview(claim);
            return OkResult(result);
        }
        // POST: /Claim/UpdateUW
        [HttpPost]
        public async Task<ActionResult> UpdateUW(ClaimDto claim)
        {
            if (claim.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            await Manager.UpdateUW(claim);
            return OkResult();
        }
        // POST: /Claim/UpdateUWA
        [HttpPost]
        public async Task<ActionResult> UpdateUWA(ClaimDto claim)
        {
            if (claim.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            var result = await Manager.UpdateUWA(claim);
            return OkResult(result);
        }
        // POST: /Claim/SetReminder
        [HttpPost]
        public async Task<ActionResult> SetReminder(ClaimDto claim)
        {
            if (claim.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            await Manager.SetReminder(claim);
            return OkResult();
        }
        // POST: /Claim/CreatePayment
        [HttpPost]
        public async Task<ActionResult> CreatePayment(ClaimPaymentDto payment)
        {
            if (payment.ClaimId.LessThen(1)) return ValidationResult("Claim Id can't less then 1.");
            await Manager.CreatePayment(payment);
            return OkResult(payment);
        }
        private void MoveDocument(ClaimDocumentDto document)
        {
            var destPath = Path.Combine(document.RootPath, "wwwroot\\ClaimDocuments", document.ClaimNumber);
            var sourceFile = Path.Combine(document.RootPath, document.FilePath, document.OrgFileName);
            if (!System.IO.File.Exists(sourceFile)) throw new FileNotFoundException(document.FileName);
            var destFile = Path.Combine(destPath, document.OrgFileName);
            if (!Directory.Exists(destPath)) Directory.CreateDirectory(destPath);
            System.IO.File.Move(sourceFile, destFile);
            document.FilePath = $"ClaimDocuments\\{document.ClaimNumber}\\";
        }
    }
}
