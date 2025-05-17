using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers
{
    public class NotificationController : BaseCRUDControllerAsync<NotificationDTO, NotificationSearchObject, NotificationInsertRequest, NotificationUpdateRequest>
    {
        public NotificationController(INotificationService service) : base(service)
        {
        }

        [HttpPatch("{id}/mark-as-read")]
        public async Task<IActionResult> MarkAsRead(int id, CancellationToken cancellationToken)
        {
            await (_service as INotificationService)!.MarkAsReadAsync(id, cancellationToken);
            return NoContent();
        }

    }
}
