using System.Collections.Generic;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public interface IClaimManager
    {
        Task<List<Dictionary<string, object>>> GetClaims(ClaimSearch search);
        Task<Dictionary<string, object>> GetClaim(int claimId);
        Task<List<Dictionary<string, object>>> GetHistory(int claimId);
        Task CreateClaim(ClaimSave claim);
        Task Create(ClaimDto claim);
        Task<ClaimNoteDto> CreateNote(ClaimNoteDto note);
        Task UpdateStatus(ClaimClosureModel claimClosure);
        Task CreateClient(ClientDto client);
        Task UpdateCover(ClaimDto claim);
        Task CreateIncident(ClaimIncidentDto incident);
        Task CreateDocument(ClaimDocumentDto document);
        Task DocumentComplete(ClaimDto claim);
        Task<Dictionary<string, object>> UpdateClaimReview(ClaimDto claim);
        Task UpdateUW(ClaimDto claim);
        Task<Dictionary<string, object>> UpdateUWA(ClaimDto claim);
        Task SetReminder(ClaimDto claim);
        Task CreatePayment(ClaimPaymentDto payment);
    }    
}