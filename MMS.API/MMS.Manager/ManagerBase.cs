using Microsoft.EntityFrameworkCore;
using MMS.Core;
using MMS.DAL;
using System;
using System.Collections.Generic;
using System.Data;

namespace MMS.Manager
{
    public class ManagerBase
    {
        public ManagerBase()
        {
            AppContexts.Resolve<MMSDbContext>();
        }
        public int ExecuteSqlCommand(string sql, params object[] parameters)
        {
            var context = (MMSDbContext)AppContexts.GetInstance(typeof(MMSDbContext));
            return context.Database.ExecuteSqlCommand(sql, parameters);
        }
        public UniqueCode GenerateSystemCode(string tableName, short addNumber = 1, string prefix = "", string suffix = "")
        {
            var context = (MMSDbContext)AppContexts.GetInstance(typeof(MMSDbContext));
            var uniqueCode = new UniqueCode();
            var parameters = new Dictionary<string, object>
            {
                { "P_TableName", tableName },
                { "P_Date", DateTime.Now.ToBD().ToString(Util.DateFormat) },
                { "P_AddNumber", addNumber },
                { "P_ClientDate", DateTime.Now.ToBD() },
                { "P_Prefix", prefix },
                { "P_Suffix", suffix }
            };
            var result = context.ExecuteScalar<string>("MakeSystemCode", CommandType.StoredProcedure, parameters);
            if (result.IsNull()) return uniqueCode;
            var dataArray = result.Split('%');
            uniqueCode.MaxNumber = Convert.ToInt32(dataArray[0]);
            if (dataArray.Length > 1) uniqueCode.SystemId = dataArray[1];
            if (dataArray.Length > 2) uniqueCode.SystemCode = dataArray[2];
            return uniqueCode;
        }
    }
}