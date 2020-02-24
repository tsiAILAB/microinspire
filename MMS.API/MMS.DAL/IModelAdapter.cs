using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace MMS.DAL
{
    public interface IModelAdapter
    {
        Task<Dictionary<string, object>> Get(string cmdText, params object[] parameters);
        Task<Dictionary<string, object>> Get(string cmdText, CommandType cmdType, Dictionary<string, object> parameters = null);

        Task<List<Dictionary<string, object>>> GetAll(string cmdText, params object[] parameters);
        Task<List<Dictionary<string, object>>> GetAll(string cmdText, CommandType cmdType, Dictionary<string, object> parameters = null);

        Task<List<Dictionary<string, object>>[]> GetResultSet(string cmdText, params object[] parameters);
        Task<List<Dictionary<string, object>>[]> GetResultSet(string cmdText, CommandType cmdType, Dictionary<string, object> parameters = null);

        Task<DataSet> GetReportSource(string cmdText, params object[] parameters);
        Task<DataSet> GetReportSource(string cmdText, CommandType cmdType, Dictionary<string, object> parameters = null);

        Task<List<Dictionary<string, object>>> GetSpFields(string procedure);
    }
}
