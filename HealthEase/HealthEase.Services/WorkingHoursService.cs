using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
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
    }
}
