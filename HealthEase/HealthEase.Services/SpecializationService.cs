using MapsterMapper;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services
{
    public class SpecializationService : BaseCRUDServiceAsync<SpecializationDTO,SpecializationSearchObject,Specialization,SpecializationUpsertRequest, SpecializationUpsertRequest>,ISpecializationService
    {
        public SpecializationService(HealthEaseContext context, IMapper mapper):base(context,mapper)
        {

        }
        public override IQueryable<Specialization> AddFilter(SpecializationSearchObject search, IQueryable<Specialization> query)
        {
            
            if (!string.IsNullOrEmpty(search?.SpecializationNameGTE))
            {
                query = query.Where(x => x.Name.ToLower().StartsWith(search.SpecializationNameGTE));
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
    }
}
