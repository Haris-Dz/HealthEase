using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;

namespace Healthease.API.Controllers
{
    public class MedicalRecordController : BaseCRUDControllerAsync<MedicalRecordDTO, MedicalRecordSearchObject, MedicalRecordInsertRequest, MedicalRecordUpdateRequest>
    {
        public MedicalRecordController(IMedicalRecordService service) : base(service)
        {

        }
    }
}
