using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;

namespace Healthease.API.Controllers
{
    public class ReviewController : BaseCRUDControllerAsync<ReviewDTO, ReviewSearchObject, ReviewInsertRequest, ReviewUpdateRequest>
    {
        public ReviewController(IReviewService service) : base(service)
        {

        }
    }
}
