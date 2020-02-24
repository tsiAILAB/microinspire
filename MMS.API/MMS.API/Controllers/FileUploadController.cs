using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Threading.Tasks;

namespace MMS.API.Controllers
{
    [ApiController, Route("[controller]/[action]")]
    public class FileUploadController : BaseController
    {
        readonly IHostingEnvironment Env;
        public FileUploadController(IHostingEnvironment env)
        {
            Env = env;
        }
        [HttpPost]
        public async Task<IActionResult> Upload(IFormFile uploadFile)
        {
            var uploadFolder = Path.Combine(Env.ContentRootPath, "wwwroot\\temp");
            if (!Directory.Exists(uploadFolder)) Directory.CreateDirectory(uploadFolder);
            var fileName = Path.GetFileName(uploadFile.FileName);
            var orgFileName = $"{Guid.NewGuid()}{Path.GetExtension(fileName)}";
            var filePath = Path.Combine(uploadFolder, orgFileName);
            if (uploadFile.Length > 0)
            {
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await uploadFile.CopyToAsync(stream);
                }
            }
            return OkResult(new { FileName = fileName, OrgFileName = orgFileName, FilePath = "wwwroot\\temp", RootPath = Env.ContentRootPath });
        }
    }
}
