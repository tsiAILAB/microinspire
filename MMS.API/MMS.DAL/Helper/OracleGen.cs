namespace MMS.DAL
{
    internal class OracleGen : ISqlGen
    {
        public string DefaultSchema()
        {
            return "";
        }

        public string IsNullFunction()
        {
            return "NVL";
        }

        public string QuoteIdentifier(string name)
        {
            return "\"" + name.Replace("\"", "\"\"") + "\"";
        }

        public string QuoteIdentifierStoreFunctionName(string name)
        {
            if (!name.Contains("."))
                return "\"" + name + "\"";
            int num = 0;
            for (int index = name.IndexOf("."); index != -1; index = name.IndexOf(".", index + 1))
                ++num;
            if (num == 1)
                return "\"" + name.Replace(".", "\".\"") + "\"";
            int length = name.LastIndexOf(".");
            return "\"" + name.Substring(0, length) + "\".\"" + name.Substring(length + 1) + "\"";
        }
    }
}