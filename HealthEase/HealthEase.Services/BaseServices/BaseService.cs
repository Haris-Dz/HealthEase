using HealthEase.Model.SearchObjects;
using HealthEase.Model;
using HealthEase.Services.BaseServiceInterfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using HealthEase.Services.Database;
using MapsterMapper;
using HealthEase.Model.Exceptions;

namespace HealthEase.Services.BaseServices
{
    public class BaseService<TModel, TSearch, TDbEntity> : IService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public HealthEaseContext Context { get; }
        public IMapper Mapper { get; }

        public BaseService(HealthEaseContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public PagedResult<TModel> GetPaged(TSearch search)
        {
            List<TModel> result = new List<TModel>();

            var query = Context.Set<TDbEntity>().AsQueryable();

            if (!string.IsNullOrEmpty(search?.IncludeTables))
            {
                query = ApplyIncludes(query, search.IncludeTables);
            }
            query = AddFilter(search, query);

            int count = query.Count();

            if (!string.IsNullOrEmpty(search?.OrderBy) && !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true && (search?.RetrieveAll.HasValue == false || search?.RetrieveAll == null))
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = query.ToList();

            result = Mapper.Map(list, result);
            CustomMapPagedResponse(result);

            PagedResult<TModel> pagedResult = new PagedResult<TModel>();
            pagedResult.ResultList = result;
            pagedResult.Count = count;

            return pagedResult;
        }

        public virtual void CustomMapPagedResponse(List<TModel> result) { }

        private IQueryable<TDbEntity> ApplyIncludes(IQueryable<TDbEntity> query, string includes)
        {
            try
            {
                var tableIncludes = includes.Split(',');
                query = tableIncludes.Aggregate(query, (current, inc) => current.Include(inc));
            }
            catch (Exception)
            {
                throw new UserException("Incorrect include list!");
            }

            return query;
        }

        public IQueryable<TDbEntity> ApplySorting(IQueryable<TDbEntity> query, string sortColumn, string sortDirection)
        {
            var entityType = typeof(TDbEntity);
            var property = entityType.GetProperty(sortColumn);
            if (property == null)
            {
                throw new UserException($"Sorting column '{sortColumn}' does not exist.");
            }
                var parameter = Expression.Parameter(entityType, "x");
                var propertyAccess = Expression.MakeMemberAccess(parameter, property);
                var orderByExpression = Expression.Lambda(propertyAccess, parameter);

                string methodName = "";

                var sortDirectionToLower = sortDirection.ToLower();

                methodName = sortDirectionToLower == "desc" || sortDirectionToLower == "descending" ? "OrderByDescending" :
                    sortDirectionToLower == "asc" || sortDirectionToLower == "ascending" ? "OrderBy" : "";

                if (methodName == "")
                {
                    return query;
                }

                var resultExpression = Expression.Call(typeof(Queryable), methodName,
                                                       new Type[] { entityType, property.PropertyType },
                                                       query.Expression, Expression.Quote(orderByExpression));

                return query.Provider.CreateQuery<TDbEntity>(resultExpression);
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }
        public TModel GetById(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);
            if (entity == null)
            {
                throw new UserException("Unable to find an object with the provided ID!");
            }

            var mappedObj = Mapper.Map<TModel>(entity);
                CustomMapResponse(mappedObj);
                return mappedObj;
        }

        public virtual void CustomMapResponse(TModel mappedObj) { }

    }
}
