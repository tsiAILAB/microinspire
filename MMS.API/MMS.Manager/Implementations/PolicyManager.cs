using MMS.Core;
using MMS.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public class PolicyManager : ManagerBase, IPolicyManager
    {
        readonly IRepository<Policy> PoRepo;
        readonly IRepository<PolicyClient> PcRepo;
        readonly IRepository<PolicyAsset> AsRepo;
        readonly IRepository<Client> ClRepo;
        readonly IRepository<PolicyNote> PNRepo;
        readonly IRepository<User> USRepo;
        readonly IRepository<Claim> CLMRepo;
        readonly IRepository<Product> PRRepo;
        readonly IRepository<Benefit> BERepo;
        readonly IRepository<ProductBenefit> PBERepo;
        readonly IRepository<ProductConfig> PCORepo;
        readonly IRepository<Configuration> ConfigRepo;
        readonly IModelAdapter Adapter;
        public PolicyManager(IRepository<Policy> poRepo,
            IRepository<PolicyClient> pcRepo,
            IRepository<PolicyAsset> asRepo,
            IRepository<Client> clRepo,
            IRepository<PolicyNote> pnRepo,
            IRepository<User> usRepo,
            IRepository<Claim> clmRepo,
            IRepository<Product> prRepo,
            IRepository<Benefit> beRepo,
            IRepository<ProductBenefit> pbeRepo,
            IRepository<ProductConfig> pcoRepo,
            IRepository<Configuration> configRepo,
            IModelAdapter adapter)
        {
            PoRepo = poRepo;
            PcRepo = pcRepo;
            AsRepo = asRepo;
            ClRepo = clRepo;
            PNRepo = pnRepo;
            USRepo = usRepo;
            CLMRepo = clmRepo;
            PRRepo = prRepo;
            BERepo = beRepo;
            PBERepo = pbeRepo;
            PCORepo = pcoRepo;
            ConfigRepo = configRepo;
            Adapter = adapter;
        }

        public async Task<List<Dictionary<string, object>>> GetPolicies(PolicySearch search)
        {
            var result = await Adapter.GetAll("PolicySearch @0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10",
               AppContexts.User.UserId, search.ExternalId, search.PolicyNumber, search.FirstName, search.LastName, search.PersonalId, search.PartnerId, search.ProductId, search.SalesReference, search.PolicyStatus, search.ContributionExtRef);
            return result;
        }

        public async Task<bool> UseExternal(string externalId)
        {
            var policy = await PoRepo.FirstOrDefaultAsync(p => p.ExternalId == externalId);
            return policy.IsNotNull();
        }

        public async Task<Dictionary<string, object>> GetPolicyByExternal(string externalId)
        {
            var result = await Adapter.Get(@"SELECT PO.PolicyId, PO.PartnerId, PO.ProductId, CLI.ClientId, CLI.FirstName, CLI.LastName,
	                                            CLI.MobileNo, CLI.PersonalId, CLI.Gender, CLI.AgeAtCreationDate, CLI.Relationship
                                            FROM [Policy] AS PO	
	                                            LEFT JOIN
	                                            (
		                                            SELECT PC.PolicyId, CL.ClientId, CL.FirstName, Cl.LastName, CL.MobileNo, CL.PersonalId, CL.Gender, CL.AgeAtCreationDate, CL.Relationship
			                                            FROM PolicyClient AS PC
		                                            LEFT JOIN Client AS CL ON PC.ClientId = CL.ClientId
		                                            WHERE CL.ClientType = 'Primary Insured'
	                                            ) AS CLI ON PO.PolicyId = CLI.PolicyId
	                                            INNER JOIN UserAccess(@0) AS UA ON PO.PartnerId = UA.PartnerId
                                            WHERE ExternalId = @1",
               AppContexts.User.UserId, externalId);
            return result;
        }

        public async Task<Dictionary<string, object>> GetNotifier(int policyId, string clientType)
        {
            var result = await Adapter.Get(@"SELECT CL.ClientId, CL.FirstName, Cl.LastName, CL.MobileNo, CL.PersonalId, CL.Gender, CL.AgeAtCreationDate, CL.Location, CL.Email, CL.Relationship
	                                            FROM PolicyClient AS PC
                                            INNER JOIN Client AS CL ON PC.ClientId = CL.ClientId
                                                WHERE CL.ClientType = @0
                                            AND PC.PolicyId = @1",
               clientType, policyId);
            return result;
        }

        public async Task<PolicySave> GetPolicy(int policyId)
        {
            var policyResult = new PolicySave();

            var policy = (from po in PoRepo.Entities
                          join pr in PRRepo.Entities
                                on po.ProductId equals pr.ProductId
                          join be in BERepo.Entities
                              on po.BenefitId equals be.BenefitId
                          where po.PolicyId.Equals(policyId)
                          select new PolicyDto
                          {
                              PolicyId = po.PolicyId,
                              PolicyNumber = po.PolicyNumber,
                              PartnerId = po.PartnerId,
                              ProductId = po.ProductId,
                              BenefitId = po.BenefitId,
                              PolicyStart = po.PolicyStart,
                              PolicyEnd = po.PolicyEnd,
                              SalesReference = po.SalesReference,
                              ContributionExtRef = po.ContributionExtRef,
                              ExternalId = po.ExternalId,
                              LoanAmount = po.LoanAmount,
                              CoverStartDate = po.CoverStartDate,
                              TermMonths = po.TermMonths,
                              CoverEndDate = po.CoverEndDate,
                              AccountNo = po.AccountNo,
                              Category = po.Category,
                              OfficerId = po.OfficerId,
                              OfficerName = po.OfficerName,
                              CentreLocation = po.CentreLocation,
                              Cycle = po.Cycle,
                              RequestedEndDate = po.RequestedEndDate,
                              EndReason = po.EndReason,
                              PolicyStatus = po.PolicyStatus,
                              ProductName = pr.Name,
                              BenefitName = be.Name,
                              CreatedBy = po.CreatedBy,
                              CreatedAt = po.CreatedAt,
                              CreatedIP = po.CreatedIP,
                              RowVersion = po.RowVersion
                          }).FirstOrDefault();

            var asset = await AsRepo.FirstOrDefaultAsync(a => a.PolicyId == policyId);
            var clients = (from pc in PcRepo.Entities
                           join cl in ClRepo.Entities
                                 on pc.ClientId equals cl.ClientId
                           where pc.PolicyId.Equals(policyId)
                           select new ClientDto
                           {
                               ClientId = pc.ClientId,
                               ClientType = cl.ClientType,
                               AgeAtCreationDate = cl.AgeAtCreationDate,
                               Relationship = cl.Relationship,
                               FirstName = cl.FirstName,
                               LastName = cl.LastName,
                               MobileNo = cl.MobileNo,
                               AccountNo = cl.AccountNo,
                               DateofBirth = cl.DateofBirth,
                               Gender = cl.Gender,
                               MaritalStatus = cl.MaritalStatus,
                               PersonalIdType = cl.PersonalIdType,
                               PersonalId = cl.PersonalId,
                               Address = cl.Address,
                               PostalCode = cl.PostalCode,
                               Email = cl.Email,
                               Location = cl.Location,
                               Language = cl.Language,
                               Communication = cl.Communication,
                               CreatedBy = cl.CreatedBy,
                               CreatedAt = cl.CreatedAt,
                               CreatedIP = cl.CreatedIP,
                               RowVersion = cl.RowVersion,
                               PCId = pc.PCId,
                               PolicyId = pc.PolicyId,
                               Editable = policy.PolicyStatus == "Active"
                           })
                        .ToList();
            var notes = (from no in PNRepo.Entities
                         join us in USRepo.Entities
                               on no.CreatedBy equals us.UserId
                         where no.PolicyId.Equals(policyId)
                         select new PolicyNoteDto
                         {
                             PolicyId = no.PolicyId,
                             NoteId = no.NoteId,
                             Note = no.Note,
                             CreatedAtDate = no.CreatedAt.ToString("MMM dd yyyy hh:mm:ss:ffftt"),
                             CreatedByName = $"{us.FirstName} {us.LastName}",
                             CreatedBy = no.CreatedBy,
                             CreatedAt = no.CreatedAt,
                             CreatedIP = no.CreatedIP,
                             RowVersion = no.RowVersion
                         })
                        .ToList();
            policyResult.Policy = policy.MapTo<PolicyDto>();
            policyResult.Asset = asset.MapTo<PolicyAssetDto>();
            policyResult.Clients = clients;
            policyResult.Notes = notes;
            policyResult.Claims = await Adapter.GetAll(@"SELECT CL.ClaimId, ClaimNumber, CL.ClaimStatus,
	                                                        CLI.FirstName, CLI.LastName, LB.Name AS LineBusiness,
	                                                        CL.DateOfIncident, CL.DateNotified
                                                        FROM Claim AS CL
	                                                        LEFT JOIN Client AS CLI ON CL.InsuredId = CLI.ClientId
	                                                        LEFT JOIN LineOfBusiness AS LB ON CL.BusinessId = LB.BusinessId
                                                        WHERE CL.PolicyId = @0", policyId);

            return policyResult;
        }

        public async Task Create(PolicySave policy)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                policy.Policy.SetAdded();
                policy.Policy.EntrySource = AppContexts.User.EntrySource;
                policy.Policy.PolicyStatus = "Active";
                SetNewPolicyId(policy.Policy);
                var policyId = policy.Policy.PolicyId;
                policy.Asset.PolicyId = policyId;
                var pClients = new List<PolicyClient>();
                foreach (var client in policy.Clients)
                {
                    client.SetAdded();
                    SetNewClientId(client);
                    pClients.Add(new PolicyClient { PolicyId = policyId, ClientId = client.ClientId, ModelState = ModelState.Added });
                }

                var policyEnt = policy.Policy.MapTo<Policy>();
                var clientEnts = policy.Clients.MapTo<List<Client>>();
                var policyClientEnts = pClients.MapTo<List<PolicyClient>>();
                if (policy.Asset.IsNotNull() && policy.Asset.AssetType.IsNotNullOrEmpty())
                {
                    policy.Asset.SetAdded();
                    var assetEnt = policy.Asset.MapTo<PolicyAsset>();
                    AsRepo.Add(assetEnt);
                }
                PoRepo.Add(policyEnt);
                ClRepo.AddRange(clientEnts);
                PcRepo.AddRange(policyClientEnts);

                unitOfWork.CommitChanges();
            }
            await Task.FromResult(0);
        }

        public async Task<ClientDto> SaveClient(ClientDto client)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                SetNewClientId(client);
                var pClient = new PolicyClient { PCId = client.PCId, PolicyId = client.PolicyId, ClientId = client.ClientId, ModelState = client.ModelState };
                var clientEnt = client.MapTo<Client>();
                ClRepo.Add(clientEnt);
                PcRepo.Add(pClient);
                unitOfWork.CommitChanges();
                clientEnt.MapToAuditFields(client);
                client.PCId = pClient.PCId;
                client.ClientId = clientEnt.ClientId;
            }
            return await Task.FromResult(client);
        }

        public async Task<PolicyNoteDto> CreateNote(PolicyNoteDto note)
        {
            var noteEnt = note.MapTo<PolicyNote>();
            PNRepo.Add(noteEnt);
            PNRepo.SaveChanges();
            note = (from no in PNRepo.Entities
                    join us in USRepo.Entities
                          on no.CreatedBy equals us.UserId
                    where no.NoteId.Equals(noteEnt.NoteId)
                    select new PolicyNoteDto
                    {
                        PolicyId = no.PolicyId,
                        NoteId = no.NoteId,
                        Note = no.Note,
                        CreatedAtDate = no.CreatedAt.ToString("MMM dd yyyy hh:mm:ss:ffftt"),
                        CreatedByName = $"{us.FirstName} {us.LastName}",
                        CreatedBy = no.CreatedBy,
                        CreatedAt = no.CreatedAt,
                        CreatedIP = no.CreatedIP,
                        RowVersion = no.RowVersion
                    }).FirstOrDefault();
            await Task.FromResult(0);
            return note;
        }

        public async Task EndPolicy(PolicyEndModel policyEnd)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                policyEnd.PolicyEnd = DateTime.Today;
                var policy = new Policy { PolicyId = policyEnd.PolicyId, PolicyEnd = policyEnd.PolicyEnd, RequestedEndDate = policyEnd.RequestedEndDate, EndReason = policyEnd.EndReason, PolicyStatus = "Ended", UpdatedAt = DateTime.Now.ToBD(), UpdatedBy = AppContexts.User.UserId, UpdatedIP = AppContexts.User.IPAddress };
                PoRepo.Update<Policy>(new { policy.PolicyId, policy.PolicyEnd, policy.RequestedEndDate, policy.EndReason, policy.PolicyStatus, policy.UpdatedAt, policy.UpdatedBy, policy.UpdatedIP });

                if (policyEnd.Note.IsNotNull() && policyEnd.Note.Note.IsNotNullOrEmpty())
                {
                    policyEnd.Note.SetAdded();
                    policyEnd.Note = await CreateNote(policyEnd.Note);
                }

                unitOfWork.CommitChanges();
            }
            await Task.FromResult(0);
        }

        public async Task<Dictionary<string, object>> GetDashboard()
        {
            var result = await Adapter.Get("GetDashBoard @0", AppContexts.User.UserId);
            return result;
        }

        private void SetNewPolicyId(PolicyDto policy)
        {
            if (!policy.IsAdded) return;
            var code = GenerateSystemCode("Policy");
            policy.PolicyId = code.MaxNumber;
            policy.PolicyNumber = code.SystemCode;
        }

        private void SetNewClientId(ClientDto client)
        {
            if (!client.IsAdded) return;
            var code = GenerateSystemCode("Client");
            client.ClientId = code.MaxNumber;
        }
        #region Integration

        public async Task<dynamic> GetProducts(int partnerId)
        {
            var result = PRRepo.Entities
                .Where(pat => pat.PartnerId.Equals(partnerId) && pat.IsActive.GetValueOrDefault())
                .OrderBy(o => o.SeqNo)
                .Select(pat => new { pat.ProductId, pat.Name, pat.ExternalId }).ToList();
            return await Task.FromResult(result);
        }

        public async Task<dynamic> GetBenefits(int productId)
        {
            var result = (from pben in PBERepo.Entities
                          join ben in BERepo.Entities
                                on pben.BenefitId equals ben.BenefitId into ml
                          from mp in ml.DefaultIfEmpty()
                          where pben.ProductId.Equals(productId) && (bool)pben.IsActive
                          select new { pben.BenefitId, mp.Name, pben.CoverageType, AssetType = pben.DefaultAssetType })
                        .ToList();
            return await Task.FromResult(result);
        }

        public async Task<ProductBenefitDto> GetBenefit(int productId, int benefitId)
        {
            var benefit = await PBERepo.FirstOrDefaultAsync(b => b.ProductId == productId && b.BenefitId == benefitId);
            return benefit.MapTo<ProductBenefitDto>();
        }

        public async Task<List<string>> GetProductConfigurations(int productId, string configType)
        {
            var result = PCORepo.Entities
                .Where(con => con.ProductId == productId && con.ConfigType.Equals(configType) && con.IsActive.GetValueOrDefault())
                .OrderBy(o => o.SeqNo)
                .Select(con => con.ConfigName).ToList();
            return await Task.FromResult(result);
        }

        public async Task<List<string>> GetConfigurations(string configType)
        {
            var result = ConfigRepo.Entities
                .Where(con => con.ConfigType.Equals(configType) && con.IsActive.GetValueOrDefault())
                .OrderBy(o => o.SeqNo)
                .Select(con => con.ConfigName).ToList();
            return await Task.FromResult(result);
        }

        #endregion

    }
}