using System.Data;
using System.Data.SqlClient;

namespace MMS.ClassGenerator
{
    class ConnectionManager
    {
        private readonly string connectionString;
        public ConnectionManager(string connectionString)
        {
            this.connectionString = connectionString;
        }
        public DataTable GetSchemaTable(string schema, string query, CommandType commandType)
        {
            if (commandType == CommandType.TableDirect)
                query = string.Format("SELECT * FROM {0}.{1}", schema, query);
            var connection = new SqlConnection(connectionString);
            connection.Open();
            var cmd = new SqlCommand { CommandText = query, Connection = connection };
            var reader = cmd.ExecuteReader(CommandBehavior.KeyInfo);
            var schemaT = reader.GetSchemaTable();
            reader.Close();
            return schemaT;
        }
        public static DataSet DataReaderToDataSet(IDataReader reader)
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
    }
}
