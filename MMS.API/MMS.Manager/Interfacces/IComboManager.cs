using MMS.Core;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public interface IComboManager
    {
        Task<List<ComboModel>> GetConfigurations(string configType);
        Task<List<ComboModel>> GetProductConfigurations(int productId, string configType);
        Task<List<ComboModel>> GetCountries();
        Task<List<ComboModel>> GetPartners();
        Task<List<ComboModel>> GetAllPartners();
        Task<List<ComboModel>> GetPartners(int countryId);
        Task<List<ComboModel>> GetProducts(int partnerId);
        Task<List<ComboModel>> GetBenefits();
        Task<List<ComboModel>> GetBenefits(int productId);
        Task<dynamic> GetBenefitsByProduct(int productId);
        Task<List<ComboModel>> GetBusiness(int productId);
        Task<List<ComboModel>> GetUnderWriters();
    }
}
