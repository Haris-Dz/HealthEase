using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;
using HealthEase.Services.Recommender;
using Microsoft.AspNetCore.Mvc;

namespace Healthease.API.Controllers
{
    [ApiController]
    public class DoctorController : BaseCRUDControllerAsync<DoctorDTO, DoctorSearchObject, DoctorInsertRequest, DoctorUpdateRequest>
    {
        public DoctorController(IDoctorService service) : base(service)
        {
        }
        [HttpPut("{id}/activate")]
        public async Task<DoctorDTO> ActivateAsync(int id, CancellationToken cancellationToken)
        {
            return await (_service as IDoctorService)!.ActivateAsync(id, cancellationToken);
        }

        [HttpPut("{id}/edit")]
        public async Task<DoctorDTO> EditAsync(int id, CancellationToken cancellationToken)
        {
            return await (_service as IDoctorService)!.EditAsync(id, cancellationToken);
        }
        [HttpPut("{id}/hide")]
        public async Task<DoctorDTO> HideAsync(int id, CancellationToken cancellationToken)
        {
            return await (_service as IDoctorService)!.HideAsync(id, cancellationToken);
        }
        [HttpGet("recommended")]
        public async Task<ActionResult<List<DoctorDTO>>> Recommend(int patientId)
        {
            var recommender = _service as IDoctorService;
            if (recommender == null)
                return BadRequest("Service does not support recommendations.");

            var result = await recommender.Recommend(patientId);
            return Ok(result);
        }
        [HttpPost("trainData")]
        public async Task<ActionResult> TrainData()
        {
            var trainData = _service as IDoctorService;
            if (trainData == null)
                return BadRequest("Service does not support data training.");

            trainData.TrainData();
            return Ok();
        }


    }
}
