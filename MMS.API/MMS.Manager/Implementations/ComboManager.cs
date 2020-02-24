using MMS.Core;
using MMS.DAL;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public class ComboManager : IComboManager
    {
        readonly IRepository<Configuration> ConfigRepo;
        readonly IRepository<Partner> PartRepo;
        readonly IRepository<Product> ProRepo;
        readonly IRepository<Benefit> BenRepo;
        readonly IRepository<ProductBenefit> PBenRepo;
        readonly IRepository<LineOfBusiness> BusRepo;
        readonly IRepository<ProductBusiness> PBusRepo;
        readonly IRepository<UnderWriter> UnderRepo;
        readonly IRepository<AssignedPartner> APRepo;
        readonly IRepository<Country> CoRepo;
        readonly IRepository<ProductConfig> PCoRepo;

        public ComboManager(IRepository<Configuration> configRepo,
            IRepository<Partner> partRepo,
            IRepository<Product> proRepo,
            IRepository<Benefit> benRepo,
            IRepository<ProductBenefit> pbenRepo,
            IRepository<LineOfBusiness> busRepo,
            IRepository<ProductBusiness> pbusRepo,
            IRepository<UnderWriter> underRepo,
            IRepository<AssignedPartner> apRepo,
            IRepository<Country> coRepo,
            IRepository<ProductConfig> pcoRepo)
        {
            ConfigRepo = configRepo;
            PartRepo = partRepo;
            ProRepo = proRepo;
            BenRepo = benRepo;
            PBenRepo = pbenRepo;
            BusRepo = busRepo;
            PBusRepo = pbusRepo;
            UnderRepo = underRepo;
            APRepo = apRepo;
            CoRepo = coRepo;
            PCoRepo = pcoRepo;
        }
        public async Task<List<ComboModel>> GetConfigurations(string configType)
        {
            var result = ConfigRepo.Entities
                .Where(con => con.ConfigType.Equals(configType) && con.IsActive.GetValueOrDefault())
                .OrderBy(o => o.SeqNo)
                .Select(con => new ComboModel { value = con.ConfigValue, text = con.ConfigName }).ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetProductConfigurations(int productId, string configType)
        {
            var result = PCoRepo.Entities
                .Where(con => con.ProductId == productId && con.ConfigType.Equals(configType) && con.IsActive.GetValueOrDefault())
                .OrderBy(o => o.SeqNo)
                .Select(con => new ComboModel { value = con.ConfigValue, text = con.ConfigName }).ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetCountries()
        {
            var result = CoRepo.Entities
                .Select(co => new ComboModel { value = co.CountryId.ToString(), text = co.Name }).ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetPartners()
        {
            var result = (from ap in APRepo.Entities
                          join pa in PartRepo.Entities
                                on ap.PartnerId equals pa.PartnerId
                          where ap.UserId.Equals(AppContexts.User.UserId)
                          select new ComboModel { value = ap.PartnerId.ToString(), text = pa.Name })
                       .ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetAllPartners()
        {
            var result = PartRepo.Entities
               .Where(pat => pat.IsActive.GetValueOrDefault())
               .OrderBy(o => o.SeqNo)
               .Select(pat => new ComboModel { value = pat.PartnerId.ToString(), text = pat.Name }).ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetPartners(int countryId)
        {
            var result = (from ap in APRepo.Entities
                          join pa in PartRepo.Entities
                                on ap.PartnerId equals pa.PartnerId
                          where ap.UserId.Equals(AppContexts.User.UserId) && pa.CountryId.Equals(countryId)
                          select new ComboModel { value = ap.PartnerId.ToString(), text = pa.Name })
                         .ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetProducts(int partnerId)
        {
            var result = ProRepo.Entities
                .Where(pat => pat.PartnerId.Equals(partnerId) && pat.IsActive.GetValueOrDefault())
                .OrderBy(o => o.SeqNo)
                .Select(pat => new ComboModel { value = pat.ProductId.ToString(), text = pat.Name }).ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetBenefits()
        {
            var result = BenRepo.Entities
                .Select(ben => new ComboModel { value = ben.BenefitId.ToString(), text = ben.Name }).ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetBenefits(int productId)
        {
            var result = (from pben in PBenRepo.Entities
                          join ben in BenRepo.Entities
                                on pben.BenefitId equals ben.BenefitId into ml
                          from mp in ml.DefaultIfEmpty()
                          where pben.ProductId.Equals(productId) && (bool)pben.IsActive
                          select new ComboModel { value = pben.BenefitId.ToString(), text = mp.Name })
                        .ToList();
            return await Task.FromResult(result);
        }
        public async Task<dynamic> GetBenefitsByProduct(int productId)
        {
            var result = (from pben in PBenRepo.Entities
                          join ben in BenRepo.Entities
                                on pben.BenefitId equals ben.BenefitId into ml
                          from mp in ml.DefaultIfEmpty()
                          where pben.ProductId.Equals(productId) && (bool)pben.IsActive
                          select new { value = pben.BenefitId.ToString(), text = mp.Name, pben.CoverageType, pben.DefaultAssetType, pben.DisableAssetType })
                        .ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetBusiness(int productId)
        {
            var result = (from pben in PBusRepo.Entities
                          join ben in BusRepo.Entities
                                on pben.BusinessId equals ben.BusinessId into ml
                          from mp in ml.DefaultIfEmpty()
                          where pben.ProductId.Equals(productId) && (bool)pben.IsActive
                          select new ComboModel { value = pben.BusinessId.ToString(), text = mp.Name, desc = mp.UnderWriterId.ToString() })
                        .ToList();
            return await Task.FromResult(result);
        }
        public async Task<List<ComboModel>> GetUnderWriters()
        {
            var result = UnderRepo.Entities
                .Select(un => new ComboModel { value = un.UnderWriterId.ToString(), text = un.Name }).ToList();
            return await Task.FromResult(result);
        }
        private void AddEmpty(List<ComboModel> result)
        {
            result.Insert(0, new ComboModel { value = "", text = "" });
        }
    }
}
