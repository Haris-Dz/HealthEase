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
    public class MedicalRecordEntryService : BaseCRUDServiceAsync<MedicalRecordEntryDTO, MedicalRecordEntrySearchObject, MedicalRecordEntry, MedicalRecordEntryInsertRequest, MedicalRecordEntryUpdateRequest>, IMedicalRecordEntryService
    {
        public MedicalRecordEntryService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<MedicalRecordEntry> AddFilter(MedicalRecordEntrySearchObject searchObject, IQueryable<MedicalRecordEntry> query)
        {
            if (searchObject.MedicalRecordId.HasValue)
                query = query.Where(m => m.MedicalRecordId == searchObject.MedicalRecordId.Value);

            if (searchObject.DoctorId.HasValue)
                query = query.Where(m => m.DoctorId == searchObject.DoctorId.Value);

            if (!string.IsNullOrWhiteSpace(searchObject?.EntryType))
                query = query.Where(x => x.EntryType.StartsWith(searchObject.EntryType));

            if (searchObject.EntryDateFrom.HasValue)
                query = query.Where(x => x.EntryDate >= searchObject.EntryDateFrom.Value);

            if (searchObject.EntryDateTo.HasValue)
                query = query.Where(x => x.EntryDate >= searchObject.EntryDateTo.Value);

            query = query.Where(x => !x.IsDeleted);
            return query;
        }


        public override async Task BeforeInsertAsync(MedicalRecordEntryInsertRequest request, MedicalRecordEntry entity, CancellationToken cancellationToken = default)
        {

            entity.EntryDate = DateTime.Now;
        }

    }
}
