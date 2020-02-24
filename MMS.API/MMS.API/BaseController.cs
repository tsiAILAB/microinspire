using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MMS.Core;

namespace MMS.API
{
    public class BaseController : ControllerBase
    {
        public ObjectResult OkResult(object result = null)
        {
            return CreateResult(StatusCodes.Status200OK, "OK", "Success", result);
        }

        public ObjectResult CreatedResult(object result = null)
        {
            return CreateResult(StatusCodes.Status201Created, "CREATED", "Record created successfully.", result);
        }

        public ObjectResult UpdatedResult(object result = null)
        {
            return CreateResult(StatusCodes.Status205ResetContent, "UPDATED", "Record updated successfully.", result);
        }

        public ObjectResult DeletedResult()
        {
            return CreateResult(StatusCodes.Status204NoContent, "DELETED", "Record deleted successfully.");
        }

        public ObjectResult NoContentResult(string message = "")
        {
            return CreateResult(StatusCodes.Status204NoContent, "NO_CONTENT", message);
        }

        public ObjectResult BadRequestResult(string message = "")
        {
            return CreateResult(StatusCodes.Status400BadRequest, "BAD_REQUEST", message);
        }

        public ObjectResult NotFoundResult(string message = "")
        {
            return CreateResult(StatusCodes.Status404NotFound, "NOT_FOUND", message);
        }

        public ObjectResult UnauthorizedResult(string message = "")
        {
            return CreateResult(StatusCodes.Status401Unauthorized, "UNAUTHORIZED", message);
        }

        public ObjectResult ValidationResult(string message = "")
        {
            return CreateResult(StatusCodes.Status422UnprocessableEntity, "VALIDATION", message);
        }

        public ObjectResult ServerErrorResult(string message = "")
        {
            return CreateResult(StatusCodes.Status500InternalServerError, "INTERNAL_ERROR", message);
        }

        public ObjectResult ConnectErrorResult(string message = "")
        {
            return CreateResult(StatusCodes.Status502BadGateway, "CONNECT_ERROR", message);
        }

        public ObjectResult FailureResult(string message = "")
        {
            return CreateResult(StatusCodes.Status502BadGateway, "FAILURE", message);
        }

        public ObjectResult ServiceUnavailableResult(string message = "")
        {
            return CreateResult(StatusCodes.Status503ServiceUnavailable, "SERVICE_UNAVAILABLE", message);
        }

        public ObjectResult ConnectTimeoutResult(string message = "")
        {
            return CreateResult(StatusCodes.Status504GatewayTimeout, "CONNECT_TIMEOUT", message);
        }

        private ObjectResult CreateResult(int statusCode, string responseCode, string message = "", object result = null)
        {
            if (result.IsNull())
                return new ObjectResult(new BaseResult { StatusCode = statusCode, ResponseCode = responseCode, Message = message });
            else
                return new ObjectResult(new OkResult { StatusCode = statusCode, ResponseCode = responseCode, Result = result, Message = message });
        }
    }
}
