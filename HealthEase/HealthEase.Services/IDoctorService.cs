using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services
{
    public interface IDoctorService : ICRUDServiceAsync<DoctorDTO, DoctorSearchObject, DoctorInsertRequest, DoctorUpdateRequest>
    {
        public Task<DoctorDTO> ActivateAsync(int id, CancellationToken cancellationToken = default);
        public Task<DoctorDTO> EditAsync (int id, CancellationToken cancellationToken = default);
        public Task<DoctorDTO> HideAsync (int id, CancellationToken cancellationToken = default);
        //public List<string> AllowedActions(int id);
    }
}
