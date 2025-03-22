using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using Microsoft.AspNetCore.Authorization;

namespace Healthease.API.Controllers
{
    [AllowAnonymous]
    public class SpecializationController:BaseCRUDControllerAsync<SpecializationDTO,SpecializationSearchObject,SpecializationUpsertRequest,SpecializationUpsertRequest>
    {
        public SpecializationController(ISpecializationService service):base(service)
        {

        }
    }
}
