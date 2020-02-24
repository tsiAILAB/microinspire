using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Reflection;
using System.Text;

namespace MMS.ClassGenerator
{
    internal class Generator
    {
        StringBuilder mainClass = new StringBuilder();
        StringBuilder properties = new StringBuilder();
        readonly StringBuilder parameters = new StringBuilder();
        readonly StringBuilder commonParameters = new StringBuilder();
        readonly StringBuilder insertParameters = new StringBuilder();
        readonly StringBuilder updateParameters = new StringBuilder();
        readonly StringBuilder deleteParameters = new StringBuilder();
        readonly StringBuilder createMethod = new StringBuilder();
        Dictionary<string, string> allFields = new Dictionary<string, string>();
        Dictionary<string, string> allDbFields = new Dictionary<string, string>();
        private InsertProcedure insertProcedure;
        private UpdateProcedure updateProcedure;
        private DeleteProcedure deleteProcedure;
        private ParameterInfo parameterInfo;

        public void GenerateModel(ParameterInfo paramInfo)
        {
            mainClass = new StringBuilder();
            properties = new StringBuilder();
            allFields = new Dictionary<string, string>();
            allDbFields = new Dictionary<string, string>();
            parameterInfo = paramInfo;
            insertProcedure = new InsertProcedure(parameterInfo.Schema, parameterInfo.ClassName);
            updateProcedure = new UpdateProcedure(parameterInfo.Schema, parameterInfo.ClassName);
            deleteProcedure = new DeleteProcedure(parameterInfo.Schema, parameterInfo.ClassName);
            var conManager = new ConnectionManager(parameterInfo.ConnectionString);
            var schemaTable = conManager.GetSchemaTable(parameterInfo.Schema, parameterInfo.Query, parameterInfo.TypeCommand);


            var audit = schemaTable.Select("ColumnName = 'CreatedBy'");
            if (audit.Length != 0)
                AppendUsing(parameterInfo.ClassName, "Auditable");
            else
                AppendUsing(parameterInfo.ClassName, "EntityBase");
            //properties.Append("\n\t\t#region Properties\n");
            //AppendParameters(parameterInfo);
            //AppendMethod(parameterInfo.ClassName);

            var keyFields = GetKeyFields(schemaTable);
            foreach (DataRow dr in schemaTable.Rows)
            {
                if (Convert.ToBoolean(dr["IsHidden"])) continue;
                var fieldName = dr["ColumnName"].ToString().Replace("  ", string.Empty).Replace(" ", string.Empty);
                var fieldType = dr["DataType"].ToString().Replace("System.", string.Empty);
                var dbFieldType = dr["DataTypeName"].ToString();
                var allowDbNull = Convert.ToBoolean(dr["AllowDBNull"]);
                var isIdentity = Convert.ToBoolean(dr["IsIdentity"]);
                var isReadOnly = Convert.ToBoolean(dr["IsReadOnly"]);
                var isKey = Convert.ToBoolean(dr["IsKey"]);
                if (!isKey) isKey = Convert.ToBoolean(dr["IsUnique"]);

                if (fieldName == "CreatedBy" || fieldName == "CreatedAt" || fieldName == "CreatedIP" || fieldName == "UpdatedBy" || fieldName == "UpdatedAt" || fieldName == "UpdatedIP" || fieldName == "RowVersion" || fieldName == "CompanyId")
                    continue;
                if (paramInfo.IsModel)
                    AppendProperty(fieldName, fieldType, dbFieldType, allowDbNull, isKey, isIdentity);
                else
                    AppendProperty(fieldName, fieldType, dbFieldType, allowDbNull);
                //AppendMethod(fieldName, fieldType, allowDbNull);
                if (isReadOnly && !isIdentity) continue;
                if (dr["BaseTableName"].ToString().Length == 0) continue;
                if (fieldName == "UpdatedBy" || fieldName == "UpdatedAt" || fieldName == "UpdatedIP" || isIdentity)
                    AppendUpdateParameter(fieldName, fieldType, dbFieldType, allowDbNull);
                if (fieldName != "CreatedBy" && fieldName != "CreatedAt" && fieldName != "CreatedIP")
                    updateProcedure.AddParameter(dr);
                if (isIdentity) continue;
                AppendCommonParameter(fieldName, fieldType, dbFieldType, allowDbNull);
                AppendInsertParameter(fieldName, fieldType, dbFieldType, allowDbNull);
                if (fieldName != "UpdatedBy" && fieldName != "UpdatedAt" && fieldName != "UpdatedIP")
                    insertProcedure.AddParameter(dr);
                allFields.Add(fieldName, fieldType);
                allDbFields.Add(fieldName, dbFieldType);
            }

            //AppendDeleteParameter(keyFields);
            ////properties.Append("\n\t\t#endregion\n");
            mainClass.Append(properties);
            //parameters.Append(commonParameters.Remove(commonParameters.Length - 1, 1).Append(" };"));
            //if (insertParameters.ToString() == "\n\t\t\tif (IsAdded)\n\t\t\t\tparameters = new Dictionary<string, object>(parameters) {")
            //    parameters.Append("\n\t\t\tif (IsAdded)\n\t\t\t\tparameters = new Dictionary<string, object>(parameters);");
            //else
            //    parameters.Append(insertParameters.Remove(insertParameters.Length - 1, 1).Append(" };"));
            //if (updateParameters.ToString() == "\n\t\t\tif (IsModified)\n\t\t\t\tparameters = new Dictionary<string, object>(parameters) {")
            //    parameters.Append("\n\t\t\tif (IsModified)\n\t\t\t\tparameters = new Dictionary<string, object>(parameters);");
            //else
            //    parameters.Append(updateParameters.Remove(updateParameters.Length - 1, 1).Append(" };"));
            //if (deleteParameters.ToString() == "\n\t\t\tif (IsDeleted)\n\t\t\t\tparameters = new Dictionary<string, object> {")
            //    parameters.Append("\n\t\t\tif (IsDeleted)\n\t\t\t\tparameters = new Dictionary<string, object>();");
            //else
            //    parameters.Append(deleteParameters.Remove(deleteParameters.Length - 1, 1).Append(" };"));


            //parameters.Append("\n\t\t\treturn parameters;\n\t\t}\n");
            //parameters.Append("\n\t\t#endregion\n");
            //mainClass.Append(parameters);
            //mainClass.Append(createMethod.Append("\n\t\t\t\tState = ModelState.Unchanged\n\t\t\t};\n\t\t}\n\t\t#endregion\n"));
            mainClass.Append("\n\t}\n");
            mainClass.Append("}");

            if (parameterInfo.IsModel)
                Write(parameterInfo.ClassName + ".cs", mainClass);
            if (parameterInfo.IsDTO)
                Write(parameterInfo.ClassName + ".cs", mainClass);

            mainClass.Clear();
            //mainClass.Append("/**********************System Generated***********************************/\n");
            mainClass.Append(insertProcedure);
            mainClass.Append("\nGO\n");
            mainClass.Append(updateProcedure);
            mainClass.Append("\nGO\n");
            mainClass.Append(deleteProcedure);

            if (parameterInfo.IsProcedure)
                Write(parameterInfo.ClassName + ".sql", mainClass);

            mainClass.Clear();


        }
        private static IEnumerable<DataRow> GetKeyFields(DataTable schemaTable)
        {
            var keyFields = schemaTable.Select("IsKey = true");
            if (keyFields.Length == 0)
                keyFields = schemaTable.Select("IsUnique = true");
            if (keyFields.Length == 0)
                keyFields = new[] { schemaTable.Rows[0] };
            return keyFields;
        }
        private void AppendUsing(string className, string baseClass)
        {
            if (parameterInfo.IsModel)
            {
                mainClass.Append("using System;\n");
                mainClass.Append("using System.ComponentModel.DataAnnotations;\n");
                mainClass.Append("using System.ComponentModel.DataAnnotations.Schema;\n\n");
                
                mainClass.Append("namespace " + parameterInfo.NameSpace + "\n{\n");
                mainClass.Append("\t[Table(\"" + className + "\")]\n");
                mainClass.Append("\tpublic class " + className + " : " + baseClass + "\n\t{\n");
            }
            else
            {                
                mainClass.Append("using "+ parameterInfo.NameSpace + ";\n");
                mainClass.Append("using Newtonsoft.Json;\n");
                mainClass.Append("using System;\n\n");

                mainClass.Append("namespace "+ parameterInfo.NameSpace.Replace("DAL","Manager") + "\n{\n");
                mainClass.Append("\t[AutoMap(typeof(" + className.Replace("Dto", "") + ")), Serializable]\n");
                mainClass.Append("\tpublic class " + className + " : " + baseClass + "\n\t{\n");
            }
        }
        private void AppendProperty(string fieldName, string fieldType, string dbFieldType, bool allowDbNull, bool isKeyField, bool isIdentity)
        {
            var requared = string.Empty;
            if (!allowDbNull && fieldType == "String") requared = "[Required]";
            if (allowDbNull && fieldType != "String" && fieldType != "Byte[]") fieldType = fieldType + "?";
            var keyString = "";
            if (isKeyField) keyString = "[Key]";
            if (!string.IsNullOrEmpty(keyString) && !string.IsNullOrEmpty(requared) && !isIdentity)
            {
                keyString = "[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]";
                requared = "";
            }
            else if (!string.IsNullOrEmpty(keyString) && !string.IsNullOrEmpty(requared))
            {
                keyString = "[Key]";
                requared = "";
            }
            else if (!string.IsNullOrEmpty(keyString) && !isIdentity)
            {
                keyString = "[Key, DatabaseGenerated(DatabaseGeneratedOption.None)]";
                requared = "";
            }
            if (dbFieldType == "date")
                properties.Append("\t\t[Column(TypeName = \"date\")]\n");
            else if (dbFieldType == "time")
                properties.Append("\t\t[Column(TypeName = \"time\")]\n");
            else
                properties.Append("\t\t" + keyString + requared + "\n");
            properties.Append("\t\tpublic " + GetField(fieldType) + " " + fieldName + " { get; set; }\n");
        }
        private void AppendProperty(string fieldName, string fieldType, string dbFieldType, bool allowDbNull)
        {
            if (allowDbNull && fieldType != "String") fieldType = fieldType + "?";
            properties.Append("\n\t\tprivate " + GetField(fieldType) + " " + CamelCase(fieldName) + ";\n");

            if (dbFieldType == "datetime")
                properties.Append("\t\t[JsonConverter(typeof(DateTimeConverter))]\n");
            else if (dbFieldType == "date")
                properties.Append("\t\t[JsonConverter(typeof(DateConverter))]\n");
            else if (dbFieldType == "time")
                properties.Append("\t\t[JsonConverter(typeof(TimeConverter))]\n");
            else if (dbFieldType == "bigint")
                properties.Append("\t\t[JsonConverter(typeof(LongToStringConverter))]\n");

            properties.Append("\t\tpublic " + GetField(fieldType) + " " + fieldName + " " +
                            "\n\t\t{" +
                                "\n\t\t\tget" +
                                "\n\t\t\t{" +
                                    "\n\t\t\t\treturn " + CamelCase(fieldName) + ";" +
                                "\n\t\t\t}" +
                                "\n\t\t\tset" +
                                "\n\t\t\t{" +
                                    "\n\t\t\t\tif (PropertyChanged(" + CamelCase(fieldName) + ", value))" +
                                    "\n\t\t\t\t\t" + CamelCase(fieldName) + " = value;" +
                                "\n\t\t\t}" +
                            "\n\t\t}\n");
        }
        private void AppendParameters(ParameterInfo paramInfo)
        {
            parameters.Append("\n\t\t#region ---Base Model Implementation\n");
            parameters.Append("\n\t\tpublic override Dictionary<string, object> GetParameterInfo()");
            parameters.Append("\n\t\t{");
            //parameters.Append("\n\t\t\tDictionary<string, object> parameters = null;");
            insertParameters.Append("\n\t\t\tif (IsAdded)");
            insertParameters.Append("\n\t\t\t\tparameters = new Dictionary<string, object>(parameters) {");
            updateParameters.Append("\n\t\t\tif (IsModified)");
            updateParameters.Append("\n\t\t\t\tparameters = new Dictionary<string, object>(parameters) {");
            deleteParameters.Append("\n\t\t\tif (IsDeleted)");
            deleteParameters.Append("\n\t\t\t\tparameters = new Dictionary<string, object> { { \"TableName\", \"" + parameterInfo.Schema + "." + paramInfo.ClassName + "\"},");
            commonParameters.Append("\n\t\t\tvar parameters = new Dictionary<string, object> { { \"TableName\", \"" + parameterInfo.Schema + "." + paramInfo.ClassName + "\"},");
        }
        private void AppendMethod(string className)
        {

            createMethod.Append("\n\t\t#region ---Delegate Method Implementation\n");
            createMethod.Append("\n\t\tpublic static " + className + " Create" + className + "(Dictionary<string, object> fields)");
            createMethod.Append("\n\t\t{");
            createMethod.Append("\n\t\t\treturn new " + className + "\n\t\t\t{");
        }
        private void AppendMethod(string fieldName, string fieldType, bool allowDbNull)
        {
            var orgType = fieldType;
            if (allowDbNull && fieldType != "String") fieldType = fieldType + "?";
            if (orgType == "TimeSpan")
                if (allowDbNull)
                    createMethod.Append("\n\t\t\t\t" + CamelCase(fieldName) + " = fields[\"" + fieldName + "\"].MapTimeNullableField(),");
                else
                    createMethod.Append("\n\t\t\t\t" + CamelCase(fieldName) + " = fields[\"" + fieldName + "\"].MapTimeField(),");
            else
                createMethod.Append("\n\t\t\t\t" + CamelCase(fieldName) + " = fields[\"" + fieldName + "\"].MapField<" + GetField(fieldType) + ">(),");
        }
        private void AppendCommonParameter(string fieldName, string fieldType, string dbFieldType, bool allowDbNull)
        {
            if (fieldName != "AddedBy" && fieldName != "AddedDate" && fieldName != "DateAdded" && fieldName != "AddedIP" && fieldName != "AddedPC" && fieldName != "UpdatedBy" && fieldName != "UpdatedAt" && fieldName != "DateUpdated" && fieldName != "UpdatedIP" && fieldName != "UpdatedPC")
                AppendParameter(commonParameters, fieldName, fieldType, dbFieldType, allowDbNull);
        }
        private void AppendInsertParameter(string fieldName, string fieldType, string dbFieldType, bool allowDbNull)
        {
            if (fieldName == "AddedBy" || fieldName == "AddedDate" || fieldName == "DateAdded" || fieldName == "AddedIP" || fieldName == "AddedPC")
                AppendParameter(insertParameters, fieldName, fieldType, dbFieldType, allowDbNull);
        }
        private void AppendUpdateParameter(string fieldName, string fieldType, string dbFieldType, bool allowDbNull)
        {
            AppendParameter(updateParameters, fieldName, fieldType, dbFieldType, allowDbNull);
        }
        private void AppendDeleteParameter(IEnumerable<DataRow> keyFields)
        {
            foreach (var keyField in keyFields)
            {
                updateProcedure.AddKeyParameter(keyField);
                deleteProcedure.AddParameter(keyField);
                deleteProcedure.AddKeyParameter(keyField);
                var fieldName = keyField["ColumnName"].ToString().Replace("  ", string.Empty).Replace(" ", string.Empty);
                var fieldType = keyField["DataType"].ToString().Replace("System.", string.Empty);
                var dbFieldType = keyField["DataTypeName"].ToString();
                var allowDbNull = Convert.ToBoolean(keyField["AllowDBNull"]);
                AppendParameter(deleteParameters, fieldName, fieldType, dbFieldType, allowDbNull);
            }
        }
        private static void AppendParameter(StringBuilder parameter, string fieldName, string fieldType, string dbFieldType, bool allowDbNull)
        {
            var value = string.Empty;
            if (fieldType == "DateTime" && dbFieldType == "datetime")
                value = ".Value(Util.DateTimeFormat)";
            else if (fieldType == "DateTime" && dbFieldType == "date")
                value = ".Value()";
            else if (fieldType == "TimeSpan" && dbFieldType == "time")
                value = ".Value(Util.TimeFormat)";
            else if (allowDbNull)
                value = ".Value()";
            parameter.Append(" { \"" + fieldName + "\", " + fieldName + "" + value + " },");
        }
        private static string GetField(string fieldType)
        {
            if (fieldType == "String")
                return "string";
            if (fieldType == "Boolean")
                return "bool";
            if (fieldType == "Boolean?")
                return "bool?";
            if (fieldType == "Int16")
                return "short";
            if (fieldType == "Int16?")
                return "short?";
            if (fieldType == "Int32")
                return "int";
            if (fieldType == "Int32?")
                return "int?";
            if (fieldType == "Int64")
                return "long";
            if (fieldType == "Int64?")
                return "long?";
            if (fieldType == "Decimal")
                return "decimal";
            if (fieldType == "Decimal?")
                return "decimal?";
            if (fieldType == "Double")
                return "double";
            if (fieldType == "Double?")
                return "double?";
            if (fieldType == "Byte[]")
                return "byte[]";
            return fieldType;
        }
        public static string CamelCase(string input)
        {
            return input.Substring(0, 1).ToLower() + input.Substring(1);
        }
        private static void Write(string fileName, StringBuilder content)
        {
            var filePath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\" + fileName;
            using (var file = new StreamWriter(filePath))
            {
                file.Write(content.ToString());
            }
        }
        public static string SeparateWords(string input)
        {
            var sepWord = string.Empty;
            var i = -1;
            foreach (var ch in input)
            {
                i++;
                if (i != 0 && Char.ToUpper(ch) == ch)
                {
                    sepWord += ' ';
                }
                sepWord += ch;
            }
            return sepWord;
        }
    }
}
