using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using Microsoft.AspNetCore.Authorization;

namespace Healthease.API.Controllers
{
    [AllowAnonymous]
    public class RoleController : BaseCRUDControllerAsync<RoleDTO, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>
    {
        public RoleController(IroleService service) : base(service)
        {

        }
    }
}
