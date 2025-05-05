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

    }
}
