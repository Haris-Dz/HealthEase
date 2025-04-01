using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers
{
    [ApiController]
    public class PatientController : BaseCRUDControllerAsync<PatientDTO, PatientSearchObject, PatientInsertRequest, PatientUpdateRequest>
    {
        public PatientController(IPatientService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public PatientDTO Login(string username, string password)
        {
            return (_service as IPatientService).Login(username, password);
        }
        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<PatientDTO> InsertAsync(PatientInsertRequest request, CancellationToken cancellationToken )
        {
            return await (_service as IPatientService).InsertAsync(request,cancellationToken);
        }
    }
}