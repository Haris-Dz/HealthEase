using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;

namespace Healthease.API.Controllers
{
    public class MedicalRecordEntryController : BaseCRUDControllerAsync<MedicalRecordEntryDTO, MedicalRecordEntrySearchObject, MedicalRecordEntryInsertRequest, MedicalRecordEntryUpdateRequest>
    {
        public MedicalRecordEntryController(IMedicalRecordEntryService service) : base(service)
        {

        }
    }
}
