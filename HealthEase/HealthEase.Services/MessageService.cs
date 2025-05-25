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

namespace HealthEase.Services
{

    public class MessageService : BaseCRUDServiceAsync<MessageDTO, MessageSearchObject, Message, MessageInsertRequest, MessageUpdateRequest>, IMessageService
    {
        public MessageService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Message> AddFilter(MessageSearchObject searchObject, IQueryable<Message> query)
        {
            if (searchObject.PatientId.HasValue)
                query = query.Where(m => m.PatientId == searchObject.PatientId.Value);

            if (searchObject.UserId.HasValue)
                query = query.Where(m => m.UserId == searchObject.UserId.Value);

            if (!string.IsNullOrEmpty(searchObject.TextGTE))
                query = query.Where(m => m.Content.Contains(searchObject.TextGTE));


            return query.Include(x=>x.Patient).Include(x=>x.User);
        }

        public override async Task BeforeInsertAsync(MessageInsertRequest request, Message entity, CancellationToken cancellationToken = default)
        {

            entity.IsRead = false;
            entity.SentAt = DateTime.Now;
        }
    }
}
