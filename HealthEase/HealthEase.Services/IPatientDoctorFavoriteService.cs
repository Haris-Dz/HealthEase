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
    public interface IPatientDoctorFavoriteService 
    {
        Task<PatientDoctorFavoriteDTO?> ToggleFavoriteAsync(PatientDoctorFavoriteInsertRequest request, CancellationToken cancellationToken = default);

        Task<IEnumerable<PatientDoctorFavoriteDTO>> GetAllFavoritesByPatientIdAsync(int patientId, CancellationToken cancellationToken = default);

        Task DeleteAsync(int patientId, int doctorId, CancellationToken cancellationToken = default);
    }
}
