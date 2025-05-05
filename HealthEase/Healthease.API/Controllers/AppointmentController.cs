using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;

namespace Healthease.API.Controllers
{
    public class AppointmentController : BaseCRUDControllerAsync<AppointmentDTO, AppointmentSearchObject, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        public AppointmentController(IAppointmentService service) : base(service)
        {

        }
    }
}
