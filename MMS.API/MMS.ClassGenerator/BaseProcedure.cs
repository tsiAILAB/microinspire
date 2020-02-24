using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace MMS.ClassGenerator
{
    abstract class BaseProcedure
    {
        protected string Schema { get; }
        protected string TableName { get; }
        protected Dictionary<string, string> KeyFields { get; } = new Dictionary<string, string>();
        protected Dictionary<string, string> ParamFields { get; } = new Dictionary<string, string>();
        protected ProcedureType ProcType { private get; set; }
        protected internal BaseProcedure(string schema, string tableName)
        {
            Schema = schema;
            TableName = tableName;
        }
        protected internal void AddParameter(DataRow field)
        {
            var param = GetFieldType(field["ColumnName"].ToString(), field["DataTypeName"].ToString(),
                 Convert.ToInt32(field["ColumnSize"]), Convert.ToInt32(field["NumericPrecision"]),
                 Convert.ToInt32(field["NumericScale"]));
            if (!ParamFields.ContainsKey(field["ColumnName"].ToString()))
                ParamFields.Add(field["ColumnName"].ToString(), param);
        }
        protected internal void AddKeyParameter(DataRow field)
        {
            if (!KeyFields.ContainsKey(field["ColumnName"].ToString()))
                KeyFields.Add(field["ColumnName"].ToString(), "@" + field["ColumnName"]);
        }
        protected string CreateProcedure(StringBuilder body)
        {
            var procName = string.Format("{0}{1}", ProcType, TableName);
            var procBuilder = new StringBuilder();
            procBuilder.Append("IF OBJECT_ID('" + Schema + "." + procName + "') IS NOT NULL\n");
            procBuilder.Append("\tDROP PROC " + Schema + "." + procName + "\n");
            procBuilder.Append("GO\n");
            procBuilder.Append("CREATE PROC [" + Schema + "].[" + procName + "]\n");
            procBuilder.Append(GetParameterString());
            procBuilder.Append("\nAS\n");
            procBuilder.Append("BEGIN\n\n");
            procBuilder.Append(body);
            procBuilder.Append("\nEND\n");
            return procBuilder.ToString();
        }
        private string GetParameterString()
        {
            var parameters = new StringBuilder();
            foreach (var param in ParamFields)
            {
                parameters.Append("\t" + param.Value + ",\n");
            }
            return parameters.Length == 0 ? string.Empty : parameters.Remove(parameters.Length - 2, 2).ToString();
        }
        private static string GetFieldType(string fieldName, string dataType, int columnSize, int precision, int scale)
        {
            switch (dataType.ToLower())
            {
                case "char":
                case "nchar":
                case "nvarchar":
                case "varchar":
                    return "@" + fieldName + " " + dataType + "(" + columnSize + ")";
                case "decimal":
                case "numeric":
                    return "@" + fieldName + " " + dataType + "(" + precision + ", " + scale + ")";
                case "time":
                    return "@" + fieldName + " datetime";
                default:
                    return "@" + fieldName + " " + dataType;
            }
        }
        protected abstract string GenerateScript();
    }
}
