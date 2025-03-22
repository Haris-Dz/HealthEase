using HealthEase.Model.SearchObjects;
using HealthEase.Model;
using HealthEase.Services.BaseServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers.BaseControllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class BaseControllerAsync<TModel, TSearch> : ControllerBase where TSearch : BaseSearchObject
    {
        private readonly IServiceAsync<TModel, TSearch> _service;

        public BaseControllerAsync(IServiceAsync<TModel, TSearch> service)
        {
            _service = service;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public virtual Task<PagedResult<TModel>> GetList([FromQuery] TSearch searchObject, CancellationToken cancellationToken = default)
        {
            return _service.GetPagedAsync(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public virtual Task<TModel> GetById(int id, CancellationToken cancellationToken = default)
        {
            return _service.GetByIdAsync(id, cancellationToken);
        }
    }
}
