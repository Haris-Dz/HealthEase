using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers
{
    [ApiController]
    public class WorkingHoursController : BaseCRUDControllerAsync<WorkingHoursDTO, WorkingHoursSearchObject, WorkingHoursUpsertRequest, WorkingHoursUpsertRequest>
    {
        public WorkingHoursController(IWorkingHoursService service) : base(service)
        {
        }
    }
}
