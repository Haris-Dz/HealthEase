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
    public class MedicalRecordService : BaseCRUDServiceAsync<MedicalRecordDTO, MedicalRecordSearchObject, MedicalRecord, MedicalRecordInsertRequest, MedicalRecordUpdateRequest>, IMedicalRecordService
    {
        public MedicalRecordService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<MedicalRecord> AddFilter(MedicalRecordSearchObject searchObject, IQueryable<MedicalRecord> query)
        {
            if (searchObject.PatientId.HasValue)
                query = query.Where(m => m.PatientId == searchObject.PatientId.Value);

            if (!string.IsNullOrWhiteSpace(searchObject.PatientName))
            {
                query = query.Include(x => x.Patient)
                             .Where(x => (x.Patient.FirstName + " " + x.Patient.LastName)
                                           .Contains(searchObject.PatientName));
            }

            query = query.Include(m => m.Patient).Include(m=>m.Entries.Where(x=>!x.IsDeleted));
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
    }
}
