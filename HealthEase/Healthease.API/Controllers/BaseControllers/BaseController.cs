using HealthEase.Model.SearchObjects;
using HealthEase.Model;
using HealthEase.Services.BaseServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers.BaseControllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class BaseController<TModel, TSearch> : ControllerBase where TSearch : BaseSearchObject
    {
        private readonly IService<TModel, TSearch> _service;

        public BaseController(IService<TModel, TSearch> service)
        {
            _service = service;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public virtual PagedResult<TModel> GetList([FromQuery] TSearch searchObject)
        {
            return _service.GetPaged(searchObject);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public virtual TModel GetById(int id)
        {
            return _service.GetById(id);
        }

    }
}
