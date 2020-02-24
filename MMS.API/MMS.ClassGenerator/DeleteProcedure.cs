using System.Text;

namespace MMS.ClassGenerator
{
    class DeleteProcedure : BaseProcedure
    {
        public DeleteProcedure(string schema, string tableName)
            : base(schema, tableName)
        {
            ProcType = ProcedureType.Delete;
        }
        protected override string GenerateScript()
        {
            var deleteColumn = new StringBuilder();
            deleteColumn.Append("\tDELETE " + Schema + "." + TableName + "\n");
            deleteColumn.Append("\tWHERE\t");
            foreach (var param in KeyFields)
            {
                deleteColumn.Append(param.Key + " = @" + param.Key + " AND ");
            }
            deleteColumn = deleteColumn.Remove(deleteColumn.Length - 5, 5);
            return CreateProcedure(deleteColumn.Append("\n"));
        }
        public override string ToString()
        {
            return GenerateScript();
        }
    }
}
