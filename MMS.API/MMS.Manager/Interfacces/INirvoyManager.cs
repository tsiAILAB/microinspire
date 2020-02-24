using System.Threading.Tasks;

namespace MMS.Manager
{
    public interface INirvoyManager
    {
        Task<bool> UseMobileNumber(string mobileNumber);
        Task Create(NirvoyClientDto client);
        Task<NirvoyClientDto> GetNirvoyClient(string mobileNumber);
    }    
}