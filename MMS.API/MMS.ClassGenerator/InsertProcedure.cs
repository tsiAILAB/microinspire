using System.Text;

namespace MMS.ClassGenerator
{
    class InsertProcedure : BaseProcedure
    {
        public InsertProcedure(string schema, string tableName)
            : base(schema, tableName)
        {
            ProcType = ProcedureType.Insert;
        }
        protected override string GenerateScript()
        {
            var insertColumn = new StringBuilder();
            var valueColumn = new StringBuilder();
            insertColumn.Append("\tINSERT INTO " + Schema + "." + TableName + " (");
            valueColumn.Append("\tVALUES (");
            var i = 0;
            foreach (var param in ParamFields)
            {
                i++;
                if (i % 5 == 0)
                {
                    insertColumn.Append("\n\t\t");
                    valueColumn.Append("\n\t\t");
                }
                insertColumn.Append(param.Key + ", ");
                valueColumn.Append("@" + param.Key + ", ");
            }
            insertColumn = insertColumn.Remove(insertColumn.Length - 2, 2);
            valueColumn = valueColumn.Remove(valueColumn.Length - 2, 2);
            insertColumn.Append(")\n");
            valueColumn.Append(")\n");
            insertColumn.Append(valueColumn);
            return CreateProcedure(insertColumn);
        }
        public override string ToString()
        {
            return GenerateScript();
        }
    }
}
