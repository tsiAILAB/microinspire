using System.Text;

namespace MMS.ClassGenerator
{
    class UpdateProcedure : BaseProcedure
    {
        public UpdateProcedure(string schema, string tableName)
            : base(schema, tableName)
        {
            ProcType = ProcedureType.Update;
        }
        protected override string GenerateScript()
        {
            var updateColumn = new StringBuilder();
            updateColumn.Append("\tUPDATE " + Schema + "." + TableName + "\n");
            updateColumn.Append("\tSET\t");
            foreach (var param in ParamFields)
            {
                if (KeyFields.ContainsKey(param.Key)) continue;
                updateColumn.Append(param.Key + " = @" + param.Key + ",\n\t\t");
            }
            updateColumn = updateColumn.Remove(updateColumn.Length - 4, 4);

            updateColumn.Append("\n\tWHERE\t");
            foreach (var param in KeyFields)
            {
                updateColumn.Append(param.Key + " = " + param.Value + " AND ");
            }
            updateColumn = updateColumn.Remove(updateColumn.Length - 5, 5);

            return CreateProcedure(updateColumn.Append("\n"));
        }
        public override string ToString()
        {
            return GenerateScript();
        }
    }
}
