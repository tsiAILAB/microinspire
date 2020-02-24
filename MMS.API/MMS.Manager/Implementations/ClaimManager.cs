using MMS.Core;
using MMS.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public class ClaimManager : ManagerBase, IClaimManager
    {
        readonly IRepository<Claim> ClRepo;
        readonly IRepository<Client> CliRepo;
        readonly IRepository<ClaimIncident> CIRepo;
        readonly IRepository<ClaimDocument> CDRepo;
        readonly IRepository<ClaimNote> CnRepo;
        readonly IRepository<ClaimPayment> CpRepo;
        readonly IRepository<User> USRepo;
        readonly IRepository<RecordHistory> HIRepo;
        readonly IModelAdapter Adapter;
        public ClaimManager(IRepository<Claim> clRepo,
            IRepository<Client> cliRepo,
            IRepository<ClaimIncident> ciRepo,
            IRepository<ClaimDocument> cdRepo,
            IRepository<ClaimNote> cnRepo,
            IRepository<ClaimPayment> cpRepo,
            IRepository<User> usRepo,
            IRepository<RecordHistory> hiRepo,
            IModelAdapter adapter)
        {
            ClRepo = clRepo;
            CliRepo = cliRepo;
            CIRepo = ciRepo;
            CDRepo = cdRepo;
            CnRepo = cnRepo;
            CpRepo = cpRepo;
            USRepo = usRepo;
            HIRepo = hiRepo;
            Adapter = adapter;
        }

        public async Task<List<Dictionary<string, object>>> GetClaims(ClaimSearch search)
        {
            var result = await Adapter.GetAll("ClaimSearch @0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11",
                AppContexts.User.UserId, search.ClaimNumber, search.PartnerId, search.ProductId, search.BusinessId, search.PolicyNumber, search.InsuredFirstName, search.InsuredLastName, search.ExternalId, search.NotifierLocation, search.ClaimStatus, search.ConfirmationRequired);
            return result;
        }

        public async Task<Dictionary<string, object>> GetClaim(int claimId)
        {
            var result = await Adapter.GetResultSet("GetClaims @0", claimId);
            var claimInfo = new Dictionary<string, object>
            {
                { "Claim", result[0].Count.IsZero() ? new Dictionary<string, object>() : result[0][0] },
                { "Insured", result[1].Count.IsZero() ? new Dictionary<string, object>() : result[1][0] },
                { "Notifier", result[2].Count.IsZero() ? new Dictionary<string, object>() : result[2][0] },
                { "Incident", result[3].Count.IsZero() ? new Dictionary<string, object>() : result[3][0] },
                { "Documents", result[4] },
                { "Payments", result[5] },
                { "Notes", result[6] },
                { "PayeeNames", result[7] },
                { "Formula", result[8] }
            };
            return claimInfo;
        }

        public async Task<List<Dictionary<string, object>>> GetHistory(int claimId)
        {
            var result = await Adapter.GetAll(@"SELECT HI.*, US.FirstName + ' ' + US.LastName AS CreatedByName
		                                            FROM RecordHistory AS HI
	                                            LEFT JOIN Users AS US ON HI.CreatedBy = US.UserId
	                                            WHERE HI.KeyValue = @0
	                                            ORDER BY HI.CreatedAt DESC", claimId);
            return result;
        }

        public async Task CreateClaim(ClaimSave claim)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                claim.Claim.SetAdded();
                claim.Claim.ClaimStatus = "Registered";
                claim.Claim.StatusCreated = DateTime.Now.ToBD();
                SetNewId(claim.Claim);
                if (claim.Claim.InsuredId.GetValueOrDefault(0).IsZero())
                {
                    claim.Insured.SetAdded();
                    SetNewClientId(claim.Insured);
                    claim.Claim.InsuredId = claim.Insured.ClientId;
                    CliRepo.Add(claim.Insured.MapTo<Client>());
                }
                if (claim.Claim.NotifierId.GetValueOrDefault(0).IsZero())
                {
                    claim.Notifier.SetAdded();
                    SetNewClientId(claim.Notifier);
                    claim.Claim.NotifierId = claim.Notifier.ClientId;
                    CliRepo.Add(claim.Notifier.MapTo<Client>());
                }
                var claimEnt = claim.Claim.MapTo<Claim>();
                ClRepo.Add(claimEnt);
                AddHistory(claimEnt.ClaimId, "ClaimUpdate", "Claim Creation");
                AddHistory(claimEnt.ClaimId, "ClaimStatus", claimEnt.ClaimStatus);
                AddHistory(claimEnt.ClaimId, "ClaimUpdate", "Claim Insured Added");
                AddHistory(claimEnt.ClaimId, "ClaimUpdate", "Claim Notifier Added");
                unitOfWork.CommitChanges();
                claimEnt.MapToAuditFields(claim.Claim);
            }
            await Task.FromResult(0);
        }

        public async Task Create(ClaimDto claim)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                claim.SetAdded();
                claim.ClaimStatus = "Registered";
                claim.StatusCreated = DateTime.Now.ToBD();
                SetNewId(claim);
                var claimEnt = claim.MapTo<Claim>();
                AddHistory(claimEnt.ClaimId, "ClaimUpdate", "Claim Creation");
                AddHistory(claimEnt.ClaimId, "ClaimStatus", claimEnt.ClaimStatus);
                ClRepo.Add(claimEnt);
                unitOfWork.CommitChanges();
                claimEnt.MapToAuditFields(claim);
            }
            await Task.FromResult(0);
        }

        public async Task<ClaimNoteDto> CreateNote(ClaimNoteDto note)
        {
            var noteEnt = note.MapTo<ClaimNote>();
            CnRepo.Add(noteEnt);
            CnRepo.SaveChanges();
            note = (from no in CnRepo.Entities
                    join us in USRepo.Entities
                          on no.CreatedBy equals us.UserId
                    where no.NoteId.Equals(noteEnt.NoteId)
                    select new ClaimNoteDto
                    {
                        ClaimId = no.ClaimId,
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

        public async Task UpdateStatus(ClaimClosureModel claimClosure)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                if (claimClosure.ClosureReason.IsNotNullOrEmpty())
                    claimClosure.ClosureDate = DateTime.Today;
                var claim = new Claim { ClaimId = claimClosure.ClaimId, ClosureDate = claimClosure.ClosureDate, ClosureReason = claimClosure.ClosureReason, ClaimStatus = claimClosure.ClaimStatus, StatusCreated = DateTime.Now.ToBD(), UpdatedAt = DateTime.Now.ToBD(), UpdatedBy = AppContexts.User.UserId, UpdatedIP = AppContexts.User.IPAddress };
                ClRepo.Update<Claim>(new { claim.ClaimId, claim.ClosureDate, claim.ClosureReason, claim.ClaimStatus, claim.StatusCreated, claim.UpdatedAt, claim.UpdatedBy, claim.UpdatedIP });
                AddHistory(claim.ClaimId, "ClaimStatus", claim.ClaimStatus);
                if (claimClosure.Note.IsNotNull() && claimClosure.Note.Note.IsNotNullOrEmpty())
                {
                    claimClosure.Note.SetAdded();
                    claimClosure.Note = await CreateNote(claimClosure.Note);
                }

                unitOfWork.CommitChanges();
            }
            await Task.FromResult(0);
        }

        public async Task CreateClient(ClientDto client)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                if (client.ClientId.IsZero()) client.SetAdded();
                else client.SetModified();
                SetNewClientId(client);
                var claim = new Claim { ClaimId = client.ClaimId, InsuredId = client.ClientId, NotifierId = client.ClientId, DateNotified = client.DateNotified, UpdatedAt = DateTime.Now.ToBD(), UpdatedBy = AppContexts.User.UserId, UpdatedIP = AppContexts.User.IPAddress };
                if (client.ClientType == "Primary Insured")
                    ClRepo.Update<Claim>(new { claim.ClaimId, claim.InsuredId, claim.UpdatedAt, claim.UpdatedBy, claim.UpdatedIP });
                else
                    ClRepo.Update<Claim>(new { claim.ClaimId, claim.NotifierId, claim.DateNotified, claim.UpdatedAt, claim.UpdatedBy, claim.UpdatedIP });
                var clienEnt = client.MapTo<Client>();
                AddHistory(client.ClaimId, "ClaimUpdate", client.ClientType == "Primary Insured" ? "Insured Details" : "Notifier Details");
                CliRepo.Add(clienEnt);
                unitOfWork.CommitChanges();
                clienEnt.MapToAuditFields(client);
            }
            await Task.FromResult(0);
        }

        public async Task UpdateCover(ClaimDto claim)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                var claimEnt = claim.MapTo<Claim>();
                claimEnt.SetAuditFields();
                ClRepo.Update<Claim>(new { claimEnt.ClaimId, claimEnt.BusinessId, claimEnt.DateOfIncident, claimEnt.CoverStartDate, claimEnt.CoverEndDate, claimEnt.CoverAmount, claimEnt.RevisedCoverAmount, claimEnt.UpdatedAt, claimEnt.UpdatedBy, claimEnt.UpdatedIP });
                AddHistory(claim.ClaimId, "ClaimUpdate", "Update Cover Details");
                unitOfWork.CommitChanges();
            }
            await Task.FromResult(0);
        }

        public async Task CreateIncident(ClaimIncidentDto incident)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                incident.CauseOfIncident = string.Join(',', incident.CauseOfIncidents);
                if (incident.IncidentId.IsZero()) incident.SetAdded();
                else incident.SetModified();
                var incidentEnt = incident.MapTo<ClaimIncident>();
                CIRepo.Add(incidentEnt);
                AddHistory(incident.ClaimId, "ClaimUpdate", "Line Of Business Details");
                unitOfWork.CommitChanges();
                incidentEnt.MapToAuditFields(incident);
                incident.IncidentId = incidentEnt.IncidentId;
            }
            await Task.FromResult(0);
        }

        public async Task CreateDocument(ClaimDocumentDto document)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                if (document.DocumentId.IsZero()) document.SetAdded();
                else document.SetModified();
                var documentEnt = document.MapTo<ClaimDocument>();
                CDRepo.Add(documentEnt);
                AddHistory(document.ClaimId, "ClaimUpdate", "Claim Document Added");
                unitOfWork.CommitChanges();
                documentEnt.MapToAuditFields(document);
                document.DocumentId = documentEnt.DocumentId;
                document.CreatedByName = AppContexts.User.UserName;
            }
            await Task.FromResult(0);
        }

        public async Task DocumentComplete(ClaimDto claim)
        {
            var claimEnt = claim.MapTo<Claim>();
            claimEnt.SetAuditFields();
            ClRepo.Update<Claim>(new { claimEnt.ClaimId, claimEnt.DocumentCompleteDate, claimEnt.UpdatedAt, claimEnt.UpdatedBy, claimEnt.UpdatedIP });
            await Task.FromResult(0);
        }

        public async Task<Dictionary<string, object>> UpdateClaimReview(ClaimDto claim)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                if (claim.Decision == "Approved") claim.RejectionReason = null;
                if (claim.Decision == "Rejected") claim.ApprovedAmount = null;
                claim.ReviewBy = AppContexts.User.UserId;
                claim.ReviewDate = DateTime.Now.ToBD();
                var claimEnt = claim.MapTo<Claim>();
                claimEnt.SetAuditFields();
                ClRepo.Update<Claim>(new { claimEnt.ClaimId, claimEnt.UWReviewRequired, claimEnt.ApprovedAmount, claimEnt.Decision, claimEnt.RejectionReason, claimEnt.ReviewBy, claimEnt.ReviewDate, claimEnt.UpdatedAt, claimEnt.UpdatedBy, claimEnt.UpdatedIP });
                AddHistory(claim.ClaimId, "ClaimUpdate", "Claim Review Details");
                unitOfWork.CommitChanges();
            }
            var result = await Adapter.Get("GetClaim @0", claim.ClaimId);
            return result;
        }

        public async Task UpdateUW(ClaimDto claim)
        {
            var claimEnt = claim.MapTo<Claim>();
            claimEnt.SetAuditFields();
            ClRepo.Update<Claim>(new { claimEnt.ClaimId, claimEnt.UWSentDate, claimEnt.UWExternalRef, claimEnt.UWStatus, claimEnt.UpdatedAt, claimEnt.UpdatedBy, claimEnt.UpdatedIP });
            await Task.FromResult(0);
        }

        public async Task<Dictionary<string, object>> UpdateUWA(ClaimDto claim)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                if (claim.UWDecision == "Approved") claim.UWRejectionReason = null;
                if (claim.UWDecision == "Rejected") claim.UWApprovedAmount = null;
                claim.UWReviewBy = AppContexts.User.UserId;
                claim.UWReviewDate = DateTime.Now.ToBD();
                var claimEnt = claim.MapTo<Claim>();
                claimEnt.SetAuditFields();
                ClRepo.Update<Claim>(new { claimEnt.ClaimId, claimEnt.UWAdviceDate, claimEnt.UWAdviceFrom, claimEnt.UWAdviceRef, claimEnt.UWApprovedAmount, claimEnt.UWDecision, claimEnt.UWRejectionReason, claimEnt.UWReviewBy, claimEnt.UWReviewDate, claimEnt.UpdatedAt, claimEnt.UpdatedBy, claimEnt.UpdatedIP });
                AddHistory(claim.ClaimId, "ClaimUpdate", "Underwriter Review Details");
                unitOfWork.CommitChanges();
            }
            var result = await Adapter.Get("GetClaim @0", claim.ClaimId);
            return result;
        }

        public async Task SetReminder(ClaimDto claim)
        {
            var claimEnt = claim.MapTo<Claim>();
            claimEnt.SetAuditFields();
            ClRepo.Update<Claim>(new { claimEnt.ClaimId, claimEnt.ReminderDueDate, claimEnt.ReminderComment, claimEnt.UpdatedAt, claimEnt.UpdatedBy, claimEnt.UpdatedIP });
            await Task.FromResult(0);
        }

        public async Task CreatePayment(ClaimPaymentDto payment)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                if (payment.PaymentId.IsZero()) payment.SetAdded();
                else payment.SetModified();
                var paymentEnt = payment.MapTo<ClaimPayment>();
                CpRepo.Add(paymentEnt);
                AddHistory(payment.ClaimId, "ClaimUpdate", "Payment Details");
                unitOfWork.CommitChanges();
                paymentEnt.MapToAuditFields(payment);
                payment.PaymentId = paymentEnt.PaymentId;
            }
            await Task.FromResult(0);
        }

        private RecordHistory AddHistory(int keyValue, string historyType, string description)
        {
            var recordHistory = new RecordHistory { HistoryType = historyType, KeyValue = keyValue, Description = description, ModelState = ModelState.Added };
            HIRepo.Add(recordHistory);
            return recordHistory;
        }


        private void SetNewId(ClaimDto claim)
        {
            if (!claim.IsAdded) return;
            var code = GenerateSystemCode("Claim");
            claim.ClaimId = code.MaxNumber;
            claim.ClaimNumber = code.SystemCode;
        }

        private void SetNewClientId(ClientDto client)
        {
            if (!client.IsAdded) return;
            var code = GenerateSystemCode("Client");
            client.ClientId = code.MaxNumber;
        }
    }
}