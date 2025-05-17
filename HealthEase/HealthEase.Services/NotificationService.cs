using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Model.DTOs;
using HealthEase.Model.Exceptions;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace HealthEase.Services
{
    public class NotificationService : BaseCRUDServiceAsync<NotificationDTO, NotificationSearchObject, Notification, NotificationInsertRequest, NotificationUpdateRequest>, INotificationService
    {
        public NotificationService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Notification> AddFilter(NotificationSearchObject searchObject, IQueryable<Notification> query)
        {
            if (searchObject.PatientId != null && searchObject.PatientId > 0)
            {
                query = query.Where(p => p.PatientId == searchObject.PatientId);
            }
            if (searchObject?.IsRead != null && searchObject.IsRead == false)
            {
                query = query.Where (n=>n.IsRead == false);
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.UsernameGTE))
            {
                query = query.Where(p => p.Patient.Username.ToLower().StartsWith(searchObject.UsernameGTE.ToLower()));
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
        public override async Task BeforeInsertAsync(NotificationInsertRequest request, Notification entity, CancellationToken cancellationToken = default)
        {
            entity.CreatedAt = DateTime.Now;
            entity.IsRead = false;
        }
        public async Task MarkAsReadAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await Context.Set<Notification>()
                .FirstOrDefaultAsync(x => x.NotificationId == id && !x.IsDeleted, cancellationToken);

            if (entity == null)
                throw new UserException("Notification not found.");

            entity.IsRead = true;
            await Context.SaveChangesAsync(cancellationToken);
        }
        public override IQueryable<Notification> AddInclude(IQueryable<Notification> query)
        {
            return query.Include(n => n.Patient);
        }

    }
}
