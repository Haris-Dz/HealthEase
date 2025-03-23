using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using HealthEase.Services.BaseServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers
{
    [AllowAnonymous]
    [ApiController]
    public class UserController : BaseCRUDControllerAsync<UserDTO, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        public UserController(IUserService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public UserDTO Login(string username, string password)
        {
            return (_service as IUserService).Login(username, password);
        }
    }
}
