using Core;
using MMS.DAL;
using System.Threading.Tasks;

namespace MMS.Manager
{
    public class NirvoyManager : ManagerBase, INirvoyManager
    {
        readonly IRepository<NirvoyClient> NcRepo;
        public NirvoyManager(IRepository<NirvoyClient> ncRepo)
        {
            NcRepo = ncRepo;
        }
        public async Task<bool> UseMobileNumber(string mobileNumber)
        {
            var client = await NcRepo.FirstOrDefaultAsync(p => p.MobileNumber == mobileNumber);
            return client.IsNotNull();
        }

        public async Task Create(NirvoyClientDto client)
        {
            using (var unitOfWork = new UnitOfWork())
            {
                client.SetAdded();
                client.EntrySource = AppContexts.User.EntrySource;
                SetNewClientId(client);
                var clientEnt = client.MapTo<NirvoyClient>();
                NcRepo.Add(clientEnt);
                unitOfWork.CommitChanges();
            }
            await Task.FromResult(0);
        }

        public async Task<NirvoyClientDto> GetNirvoyClient(string mobileNumber)
        {
            var client = await NcRepo.FirstOrDefaultAsync(p => p.MobileNumber == mobileNumber);
            return client.MapTo<NirvoyClientDto>();
        }

        private void SetNewClientId(NirvoyClientDto client)
        {
            if (!client.IsAdded) return;
            var code = GenerateSystemCode("NirvoyClient");
            client.ClientId = code.MaxNumber;
        }
    }
}