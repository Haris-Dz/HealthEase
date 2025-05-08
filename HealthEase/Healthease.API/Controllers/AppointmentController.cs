using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers
{
    public class AppointmentController : BaseCRUDControllerAsync<AppointmentDTO, AppointmentSearchObject, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        public AppointmentController(IAppointmentService service) : base(service)
        {

        }
        [HttpGet("status-options")]
        public IActionResult GetStatusOptions()
        {
            var statusOptions = new List<string>
            {
                "Pending",
                "Approved",
                "Declined",
                "Paid"
            };

            return Ok(statusOptions);
        }
    }
}
