using Microsoft.EntityFrameworkCore;
using Core;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Diagnostics;
using System.Threading.Tasks;

namespace MMS.DAL
{
    public class ModelAdapter : IModelAdapter
    {
        #region Get, GetAll & GetResultSet

        [DebuggerStepThrough]
        public async Task<Dictionary<string, object>> Get(string cmdText, params object[] parameters)
        {
            var queryParams = CreateParameters(parameters);
            return await Get(cmdText, CommandType.Text, queryParams);
        }
        [DebuggerStepThrough]
        public async Task<Dictionary<string, object>> Get(string cmdText, CommandType cmdType, Dictionary<string, object> parameters = null)
        {
            DbDataReader reader = null;
            try
            {
                reader = await ExecuteReader(cmdText, cmdType, parameters);
                return await Get(reader);
            }
            finally
            {
                reader.CloseReader();
            }
        }

        [DebuggerStepThrough]
        public async Task<List<Dictionary<string, object>>> GetAll(string cmdText, params object[] parameters)
        {
            var queryParams = CreateParameters(parameters);
            return await GetAll(cmdText, CommandType.Text, queryParams);
        }
        [DebuggerStepThrough]
        public async Task<List<Dictionary<string, object>>> GetAll(string cmdText, CommandType cmdType, Dictionary<string, object> parameters = null)
        {
            DbDataReader reader = null;
            try
            {
                reader = await ExecuteReader(cmdText, cmdType, parameters);
                return await GetAll(reader);
            }
            finally
            {
                reader.CloseReader();
            }
        }
        [DebuggerStepThrough]
        public async Task<List<Dictionary<string, object>>[]> GetResultSet(string cmdText, params object[] parameters)
        {
            var queryParams = CreateParameters(parameters);
            return await GetResultSet(cmdText, CommandType.Text, queryParams);
        }
        [DebuggerStepThrough]
        public async Task<List<Dictionary<string, object>>[]> GetResultSet(string cmdText, CommandType cmdType, Dictionary<string, object> parameters = null)
        {
            DbDataReader reader = null;
            var result = new List<List<Dictionary<string, object>>>();
            try
            {
                reader = await ExecuteReader(cmdText, cmdType, parameters);
                do
                {
                    result.Add(await GetAll(reader));
                } while (reader.NextResult());
                return result.ToArray();
            }
            finally
            {
                reader.CloseReader();
            }
        }

        #endregion

        #region Report Source
        [DebuggerStepThrough]
        public async Task<DataSet> GetReportSource(string cmdText, params object[] parameters)
        {
            var queryParams = CreateParameters(parameters);
            return await GetReportSource(cmdText, CommandType.Text, queryParams);
        }
        [DebuggerStepThrough]
        public async Task<DataSet> GetReportSource(string cmdText, CommandType cmdType, Dictionary<string, object> parameters = null)
        {
            IDataReader reader = null;
            var result = new List<List<Dictionary<string, object>>>();
            try
            {
                reader = await ExecuteReader(cmdText, cmdType, parameters);
                return DataReaderToDataSet(reader);
            }
            finally
            {
                reader.CloseReader();
            }
        }

        #endregion

        #region Helper Methods

        private DataSet DataReaderToDataSet(IDataReader reader)
        {
            var dataSet = new DataSet();
            do
            {
                var fieldCount = reader.FieldCount;
                var table = new DataTable();
                for (var i = 0; i < fieldCount; i++)
                {
                    table.Columns.Add(reader.GetName(i), reader.GetFieldType(i));
                }
                table.BeginLoadData();
                var values = new object[fieldCount];
                while (reader.Read())
                {
                    reader.GetValues(values);
                    table.LoadDataRow(values, true);
                }
                table.EndLoadData();
                dataSet.Tables.Add(table);
            } while (reader.NextResult());
            reader.Close();
            return dataSet;
        }
        private async Task<Dictionary<string, object>> Get(DbDataReader reader)
        {
            var cols = new List<string>();
            for (var i = 0; i < reader.FieldCount; i++)
            {
                cols.Add(reader.GetName(i));
            }
            while (await reader.ReadAsync().ConfigureAwait(false))
            {
                return GetFields(cols, reader);
            }
            return new Dictionary<string, object>();
        }
        private async Task<List<Dictionary<string, object>>> GetAll(DbDataReader reader)
        {
            var list = new List<Dictionary<string, object>>();
            var cols = new List<string>();
            for (var i = 0; i < reader.FieldCount; i++)
            {
                cols.Add(reader.GetName(i));
            }
            while (await reader.ReadAsync().ConfigureAwait(false))
            {
                list.Add(GetFields(cols, reader));
            }
            return list;
        }
        private async Task<DbDataReader> ExecuteReader(string cmdText, CommandType cmdType, Dictionary<string, object> parameters)
        {
            if (cmdText.IsNullOrEmpty()) throw new Exception("Query is blank.");
            var connection = await CreateConnection();
            try
            {
                var command = connection.CreateCommand();
                PrepareCommand(command, cmdText, cmdType);
                PrepareCommandParameter(command, parameters);
                var reader = await command.ExecuteReaderAsync().ConfigureAwait(false);
                return reader;
            }
            catch (Exception)
            {
                CloseConnection(connection);
                throw;
            }
        }
        private async Task<DbConnection> CreateConnection()
        {
            var context = (MMSDbContext)AppContexts.GetInstance(typeof(MMSDbContext));
            var connection = context.Database.GetDbConnection();
            if (connection.State == ConnectionState.Closed)
                await connection.OpenAsync().ConfigureAwait(false);
            return connection;
        }
        protected void CloseConnection(DbConnection connection)
        {
            if (connection.IsNull() || connection.State != ConnectionState.Open) return;
            connection.Close();
            connection.Dispose();
            connection = null;
        }
        private Dictionary<string, object> CreateParameters(object[] parameters)
        {
            var queryParams = new Dictionary<string, object>();
            for (var i = 0; i < parameters.Length; i++)
            {
                queryParams.Add(i.ToString(), parameters[i]);
            }
            return queryParams;
        }
        private void PrepareCommand(IDbCommand command, string cmdText, CommandType cmdType)
        {
            command.CommandType = cmdType;
            command.CommandText = cmdText;
            command.CommandTimeout = 600;
        }
        protected void PrepareCommandParameter(IDbCommand command, Dictionary<string, object> parameters)
        {
            if (parameters.IsNull() || parameters.Count.IsZero()) return;
            foreach (var param in parameters)
            {
                var parameter = command.CreateParameter();
                var value = param.Value;
                parameter.DbType = MappedDbType.GetDbType(value?.GetType());
                parameter.ParameterName = param.Key;
                parameter.Value = value.Value();
                command.Parameters.Add(parameter);
            }
        }
        private static Dictionary<string, object> GetFields(IEnumerable<string> cols, IDataRecord reader)
        {
            var values = new Dictionary<string, object>();
            foreach (var colName in cols)
            {
                var ordinal = reader.GetOrdinal(colName);
                var type = reader.GetDataTypeName(ordinal);
                var value = reader.GetValue(ordinal);
                if (value.IsNullOrDbNull())
                {
                    values[colName] = value;
                    continue;
                }
                switch (type.ToLower())
                {
                    case "bigint":
                        values[colName] = value.ToString();
                        break;
                    case "date":
                        values[colName] = ((DateTime)value).ToString(Util.SysDateFormat);
                        break;
                    case "datetime":
                        values[colName] = ((DateTime)value).ToString(Util.DateTimeFormat);
                        break;
                    case "time":
                        values[colName] = DateTime.MinValue.Add((TimeSpan)value).ToString(Util.TimeFormat);
                        break;
                    default:
                        values[colName] = value;
                        break;
                }
            }
            return values;
        }

        #endregion

        #region GetSpFields
        public async Task<List<Dictionary<string, object>>> GetSpFields(string procedure)
        {
            var cols = new List<Dictionary<string, object>>();
            var query = $@"SELECT [Name] AS FieldName, system_type_name AS FieldType
                        FROM sys.dm_exec_describe_first_result_set_for_object
                        (
                          OBJECT_ID('{procedure}'), 
                          NULL
                        );";
            var reader = await ExecuteReader(query, CommandType.Text, null);
            while (reader.Read())
            {
                var col = new Dictionary<string, object>
                {
                    { "Checked", true },
                    { "FieldName", reader["FieldName"].ToString() }
                };
                cols.Add(col);
            }
            reader.CloseReader();
            return cols;
        }
        #endregion
    }
}
