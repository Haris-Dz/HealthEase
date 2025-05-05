using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;

namespace HealthEase.Services
{
    public interface IAppointmentService : ICRUDServiceAsync<AppointmentDTO, AppointmentSearchObject, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
    }
}
