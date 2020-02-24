using System;

namespace MMS.API
{
    public class ErrorLog
    {
        public int ErrorId { get; set; }

        public int? ErrorCode { get; set; }

        public string ErrorType { get; set; }

        public string ErrorMessage { get; set; }

        public string Url { get; set; }

        public short CompanyId { get; set; }

        public string ErrorLevel { get; set; }

        public string UserAgent { get; set; }

        public string ErrorBy { get; set; }

        public DateTime ErrorAt { get; set; }

        public string ErrorIP { get; set; }

    }
}