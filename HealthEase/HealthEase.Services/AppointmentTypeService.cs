using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace HealthEase.Services
{
    public class AppointmentTypeService : BaseCRUDServiceAsync<AppointmentTypeDTO, AppointmentTypeSearchObject, AppointmentType, AppointmentTypeUpsertRequest, AppointmentTypeUpsertRequest>, IAppointmentTypeService
    {
        public AppointmentTypeService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<AppointmentType> AddFilter(AppointmentTypeSearchObject search, IQueryable<AppointmentType> query)
        {
            if (!string.IsNullOrEmpty(search?.NameGTE))
            {
                query = query.Where(x => x.Name.ToLower().StartsWith(search.NameGTE));
            }

            query = query.Where(x => !x.IsDeleted);
            return query;
        }

    }
}
