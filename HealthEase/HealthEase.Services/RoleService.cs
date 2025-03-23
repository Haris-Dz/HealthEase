using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services
{

    public class RoleService : BaseCRUDServiceAsync<RoleDTO, RoleSearchObject, Role, RoleUpsertRequest, RoleUpsertRequest>, IroleService
    {
        public RoleService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Role> AddFilter(RoleSearchObject search, IQueryable<Role> query)
        {

            if (!string.IsNullOrEmpty(search?.RoleNameGTE))
            {
                query = query.Where(x => x.RoleName.ToLower().StartsWith(search.RoleNameGTE));
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
    }




}
