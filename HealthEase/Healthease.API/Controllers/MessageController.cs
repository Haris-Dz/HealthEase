using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;

namespace Healthease.API.Controllers
{

    public class MessageController : BaseCRUDControllerAsync<MessageDTO, MessageSearchObject, MessageInsertRequest, MessageUpdateRequest>
    {
        public MessageController(IMessageService service) : base(service)
        {

        }
    }
}
