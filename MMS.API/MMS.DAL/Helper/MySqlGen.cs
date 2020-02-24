namespace MMS.DAL
{
    internal class MySqlGen : ISqlGen
    {
        public string DefaultSchema()
        {
            return "";
        }

        public string IsNullFunction()
        {
            return "IFNULL";
        }

        public string QuoteIdentifier(string name)
        {
            return "`" + name.Replace("`", "``") + "`";
        }

        public string QuoteIdentifierStoreFunctionName(string name)
        {
            return "`" + name.Replace("`", "``") + "`";
        }
    }
}