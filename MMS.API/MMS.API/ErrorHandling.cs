using MMS.Core;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System;
using System.Threading.Tasks;

namespace MMS.API
{
    public class ErrorHandling
    {
        private readonly RequestDelegate next;
        private readonly ILogger logger;
        public ErrorHandling(RequestDelegate next, ILogger logger)
        {
            this.next = next;
            this.logger = logger;
        }
        public async Task Invoke(HttpContext context)
        {
            try
            {
                await next(context);
            }
            catch (Exception ex)
            {
                await HandleExceptionAsync(context, ex);
            }
        }
        private Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            var orgException = exception.GetOriginalException();
            var errorLog = WriteLog(context, exception);            
			var err = new { errorLog.ErrorId, ErrorDate = DateTime.Today.ToString(Util.DateFormat), StatusCode = StatusCodes.Status500InternalServerError, ResponseCode = "APP_ERROR", orgException.Message };
            var result = JsonConvert.SerializeObject(err);
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = StatusCodes.Status200OK;
            return context.Response.WriteAsync(result);
        }

        private ErrorLog WriteLog(HttpContext filterContext, Exception exception)
        {
            var errorId = DateTime.Now.ToBD().ToString("hhmmssfff").ToInt();
            var errorLog = new ErrorLog
            {
                ErrorId = errorId,
                ErrorCode = exception.HResult,
                Url = filterContext.Request.Path.Value,
                ErrorType = exception.GetType().Name,
                ErrorMessage = $"Error: {exception.Message}, StackTrace: {exception.StackTrace}",
                ErrorLevel = "Critical",
                UserAgent = AppContexts.User.UserAgent,
                ErrorBy = AppContexts.User.UserName,
                ErrorAt = DateTime.Now.ToBD(),
                ErrorIP = AppContexts.GetIPAddress()
            };
            logger.LogError(errorLog);
            return errorLog;
        }
    }
}
