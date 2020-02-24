using System.Collections.Generic;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public interface IPolicyManager
    {
        Task<List<Dictionary<string, object>>> GetPolicies(PolicySearch search);
        Task<Dictionary<string, object>> GetNotifier(int policyId, string clientType);
        Task<PolicySave> GetPolicy(int policyId);
        Task<bool> UseExternal(string externalId);
        Task<Dictionary<string, object>> GetPolicyByExternal(string externalId);
        Task Create(PolicySave policy);
        Task<ClientDto> SaveClient(ClientDto client);
        Task<PolicyNoteDto> CreateNote(PolicyNoteDto note);
        Task EndPolicy(PolicyEndModel policyEnd);
        Task<Dictionary<string, object>> GetDashboard();

        //Integration
        Task<dynamic> GetProducts(int partnerId);
        Task<dynamic> GetBenefits(int productId);
        Task<ProductBenefitDto> GetBenefit(int productId, int benefitId);
        Task<List<string>> GetProductConfigurations(int productId, string configType);
        Task<List<string>> GetConfigurations(string configType);
    }    
}