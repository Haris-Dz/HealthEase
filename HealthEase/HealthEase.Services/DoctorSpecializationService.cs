using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;
using Azure.Core;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace HealthEase.Services
{
    public class DoctorSpecializationService : BaseCRUDServiceAsync<DoctorSpecializationDTO, DoctorSpecializationSearchObject, DoctorSpecialization, DoctorSpecializationUpsertRequest, DoctorSpecializationUpsertRequest>, IDoctorSpecializationService
    {
        public DoctorSpecializationService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<DoctorSpecialization> AddFilter(DoctorSpecializationSearchObject searchObject, IQueryable<DoctorSpecialization> query)
        {

            return query
                .Where(x => !x.IsDeleted);
        }
        public async Task SyncDoctorSpecializations(List<int> specializationIds, int doctorId, CancellationToken cancellationToken)
        {
            var existing = await Context.DoctorSpecializations
                .Where(x => x.DoctorId == doctorId)
                .ToListAsync(cancellationToken);

            var toAdd = specializationIds
                .Except(existing.Select(x => x.SpecializationId));

            foreach (var id in toAdd)
            {
                Context.DoctorSpecializations.Add(new DoctorSpecialization
                {
                    DoctorId = doctorId,
                    SpecializationId = id
                });
            }

            var toSoftDelete = existing
                .Where(x => !specializationIds.Contains(x.SpecializationId) && !x.IsDeleted);

            foreach (var ds in toSoftDelete)
            {
                ds.IsDeleted = true;
                ds.DeletionTime = DateTime.UtcNow;
            }

            var toReactivate = existing
                .Where(x => specializationIds.Contains(x.SpecializationId) && x.IsDeleted);

            foreach (var ds in toReactivate)
            {
                ds.IsDeleted = false;
                ds.DeletionTime = null;
            }

            await Context.SaveChangesAsync(cancellationToken);
        }


    }
}
