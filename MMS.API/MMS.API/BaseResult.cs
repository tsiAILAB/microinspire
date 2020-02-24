namespace MMS.API
{
    public class BaseResult
    {
        public int StatusCode { get; set; }
        public string ResponseCode { get; set; }
        public string Message { get; set; }
    }
}
