using HealthEase.Model.DTOs;
using HealthEase.Model.Exceptions;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services
{
    public class WorkingHoursService : BaseCRUDServiceAsync<WorkingHoursDTO, WorkingHoursSearchObject, WorkingHours, WorkingHoursUpsertRequest, WorkingHoursUpsertRequest>, IWorkingHoursService
    {
        public WorkingHoursService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<WorkingHours> AddFilter(WorkingHoursSearchObject search, IQueryable<WorkingHours> query)
        {
            if (search.UserId.HasValue)
                query = query.Where(x => x.UserId == search.UserId.Value);
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
        public override Task ValidateEntityAccessAsync(WorkingHours entity, CancellationToken cancellationToken = default)
        {
            if (entity.IsDeleted)
                throw new UserException("This record is deleted.");

            return Task.CompletedTask;
        }
        public async Task<List<WorkingHoursDTO>> BulkUpsertAsync(List<WorkingHoursUpsertRequest> requestList)
        {
            if (requestList == null || requestList.Count == 0)
                return new List<WorkingHoursDTO>();

            var userId = requestList.First().UserId;

            foreach (var req in requestList)
            {
                var existing = await Context.WorkingHours
                    .FirstOrDefaultAsync(x => x.UserId == req.UserId && x.Day == req.Day);

                if (req.StartTime == null || req.EndTime == null)
                {
                    // DELETE if there is entry
                    if (existing != null)
                        existing.IsDeleted = true;
                }
                else
                {
                    if (existing != null)
                    {
                        // UPDATE current
                        existing.StartTime = req.StartTime;
                        existing.EndTime = req.EndTime;

                        if (existing.IsDeleted)
                            existing.IsDeleted = false; // Reactivate if it was deleted before
                    }
                    else
                    {
                        // INSERT new entry
                        var entity = Mapper.Map<Database.WorkingHours>(req);
                        await Context.WorkingHours.AddAsync(entity);
                    }
                }
            }

            await Context.SaveChangesAsync();

            var updated = await Context.WorkingHours
                .Where(x => x.UserId == userId && !x.IsDeleted)
                .ToListAsync();

            return Mapper.Map<List<WorkingHoursDTO>>(updated);
        }





    }
}
