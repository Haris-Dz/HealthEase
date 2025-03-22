using MapsterMapper;
using HealthEase.Model.Exceptions;
using HealthEase.Model.SearchObjects;
using HealthEase.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Services.Database;

namespace HealthEase.Services.BaseServices
{
    public class BaseServiceAsync<TModel, TSearch, TDbEntity> : IServiceAsync<TModel, TSearch>
        where TSearch : BaseSearchObject
        where TDbEntity : class
        where TModel : class
    {
        public HealthEaseContext Context { get; }
        public IMapper Mapper { get; }

        public BaseServiceAsync(HealthEaseContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        // Fetches paged results with applied filters, sorting, and pagination
        public virtual async Task<PagedResult<TModel>> GetPagedAsync(TSearch search, CancellationToken cancellationToken = default)
        {
            List<TModel> result = new List<TModel>();

            var query = Context.Set<TDbEntity>().AsQueryable();

            if (!string.IsNullOrEmpty(search?.IncludeTables))
            {
                query = ApplyIncludes(query, search.IncludeTables); // Applies related table includes
            }

            query = AddFilter(search, query); // Adds search filters

            int count = await query.CountAsync(cancellationToken); // Counts total matching records

            if (!string.IsNullOrEmpty(search?.OrderBy) && !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection); // Applies sorting
            }

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true && (search?.RetrieveAll.HasValue == false || search?.RetrieveAll == null))
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value); // Applies pagination
            }

            var list = await query.ToListAsync(cancellationToken);
            result = Mapper.Map<List<TModel>>(list);

            await CustomMapPagedResponseAsync(result, cancellationToken); // Custom mapping for the response

            PagedResult<TModel> pagedResult = new PagedResult<TModel>();
            pagedResult.ResultList = result;
            pagedResult.Count = count;

            return pagedResult;
        }

        // Placeholder for additional custom mapping on paged response
        public virtual async Task CustomMapPagedResponseAsync(List<TModel> result, CancellationToken cancellationToken = default) { }

        // Applies table includes for related entities based on comma-separated string
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

        // Applies sorting based on specified column and direction (ASC/DESC)
        public IQueryable<TDbEntity> ApplySorting(IQueryable<TDbEntity> query, string sortColumn, string sortDirection)
        {
            var entityType = typeof(TDbEntity);
            var property = entityType.GetProperty(sortColumn);
            if (property != null)
            {
                var parameter = Expression.Parameter(entityType, "x");
                var propertyAccess = Expression.MakeMemberAccess(parameter, property);
                var orderByExpression = Expression.Lambda(propertyAccess, parameter);

                string methodName = "";

                var sortDirectionToLower = sortDirection.ToLower();

                methodName = sortDirectionToLower == "desc" || sortDirectionToLower == "descending" ? "OrderByDescending" :
                    sortDirectionToLower == "asc" || sortDirectionToLower == "ascending" ? "OrderBy" : "";

                if (methodName == "")
                {
                    return query; // If no valid sorting direction, return query unsorted
                }

                var resultExpression = Expression.Call(typeof(Queryable), methodName,
                                                       new Type[] { entityType, property.PropertyType },
                                                       query.Expression, Expression.Quote(orderByExpression));

                return query.Provider.CreateQuery<TDbEntity>(resultExpression);
            }
            else
            {
                return query; // Return unsorted if column not found
            }
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }

        public virtual async Task<TModel> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await Context.Set<TDbEntity>().FindAsync(id, cancellationToken);
            if (entity == null)
            {
                throw new UserException("Unable to find an object with the provided ID!"); 
            }

            var mappedObj = Mapper.Map<TModel>(entity);
            await CustomMapResponseAsync(mappedObj, cancellationToken); // Custom response mapping if needed
            return mappedObj;
        }

        // Placeholder for additional custom mapping on single record response
        public virtual async Task CustomMapResponseAsync(TModel mappedObj, CancellationToken cancellationToken = default) { }
    }
}
