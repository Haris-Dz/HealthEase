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
    public interface IDoctorSpecializationService : ICRUDServiceAsync<DoctorSpecializationDTO,DoctorSpecializationSearchObject , DoctorSpecializationUpsertRequest, DoctorSpecializationUpsertRequest>
    {
        Task SyncDoctorSpecializations(List<int> specializationIds, int doctorId, CancellationToken cancellationToken);
    }
}
