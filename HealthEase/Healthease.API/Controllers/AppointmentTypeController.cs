using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;

namespace Healthease.API.Controllers
{
    public class AppointmentTypeController : BaseCRUDControllerAsync<AppointmentTypeDTO, AppointmentTypeSearchObject, AppointmentTypeUpsertRequest, AppointmentTypeUpsertRequest>
    {
        public AppointmentTypeController(IAppointmentTypeService service) : base(service)
        {

        }
    }
}
