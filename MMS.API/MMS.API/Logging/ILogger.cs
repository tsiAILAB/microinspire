namespace MMS.API
{
    public interface ILogger
    {
        void LogInformation(string log);
        void LogWarning(string log);
        void LogError(ErrorLog log);
    }
}
