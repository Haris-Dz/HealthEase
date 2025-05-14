using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using HealthEase.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Healthease.API.Controllers
{
    [ApiController]
    public class WorkingHoursController : BaseCRUDControllerAsync<WorkingHoursDTO, WorkingHoursSearchObject, WorkingHoursUpsertRequest, WorkingHoursUpsertRequest>
    {
        private readonly HealthEaseContext Context;
        public WorkingHoursController(IWorkingHoursService service, HealthEaseContext context) : base(service)
        {
            Context = context;
        }

        [HttpPost("BulkUpsert")]
        public async Task<IActionResult> BulkUpsert([FromBody] List<WorkingHoursUpsertRequest> request)
        {
            var result = await (_service as IWorkingHoursService).BulkUpsertAsync(request);
            return Ok(result);
        }



    }
}
