using System.Data;

namespace MMS.ClassGenerator
{
    internal class ParameterInfo
    {
        public string Schema { get; set; }
        public string ClassName { get; set; }
        public string Query { get; set; }
        public string NameSpace { get; set; }
        public string ConnectionString { get; set; }
        public CommandType TypeCommand { get; set; }
        public bool IsModel { get; set; }
        public bool IsDTO { get; set; }
        public bool IsProcedure { get; set; }
        public bool IsUnitTest { get; set; }
        public bool IsGateway { get; set; }
    }
}
