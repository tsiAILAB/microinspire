namespace MMS.DAL
{
    internal interface ISqlGen
    {
        string DefaultSchema();
        string IsNullFunction();
        string QuoteIdentifier(string name);
        string QuoteIdentifierStoreFunctionName(string name);        
    }
}
