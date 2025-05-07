using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class PatientDoctorFavoriteController : ControllerBase
    {
        private readonly IPatientDoctorFavoriteService _favoriteService;

        public PatientDoctorFavoriteController(IPatientDoctorFavoriteService favoriteService)
        {
            _favoriteService = favoriteService;
        }

        [HttpPost("toggle")]
        public async Task<IActionResult> Toggle([FromBody] PatientDoctorFavoriteInsertRequest request, CancellationToken cancellationToken)
        {
            var result = await _favoriteService.ToggleFavoriteAsync(request, cancellationToken);
            return Ok(result);
        }

        [HttpGet("by-patient/{patientId}")]
        public async Task<IActionResult> GetByPatientId(int patientId, CancellationToken cancellationToken)
        {
            var favorites = await _favoriteService.GetAllFavoritesByPatientIdAsync(patientId, cancellationToken);
            return Ok(favorites);
        }

        [HttpDelete("{patientId:int}/{doctorId:int}")]
        public async Task<IActionResult> Delete(int patientId, int doctorId, CancellationToken cancellationToken)
        {
            await _favoriteService.DeleteAsync(patientId, doctorId, cancellationToken);
            return NoContent();
        }
    }
}
