namespace MMS.DAL
{
    internal class SqlGen : ISqlGen
    {
        public string DefaultSchema()
        {
            return "dbo";
        }

        public string IsNullFunction()
        {
            return "ISNULL";
        }

        public string QuoteIdentifier(string name)
        {
            return "[" + name.Replace("]", "]]") + "]";
        }

        public string QuoteIdentifierStoreFunctionName(string name)
        {
            return "[" + name.Replace("]", "]]") + "]";
        }
    }
}
