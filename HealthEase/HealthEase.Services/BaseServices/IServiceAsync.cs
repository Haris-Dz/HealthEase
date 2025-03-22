using HealthEase.Model.SearchObjects;
using HealthEase.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.BaseServices
{
    public interface IServiceAsync<TModel, TSearch> where TSearch : BaseSearchObject
    {
        public Task<PagedResult<TModel>> GetPagedAsync(TSearch search, CancellationToken cancellationToken = default);
        public Task<TModel> GetByIdAsync(int id, CancellationToken cancellationToken = default);

    }
}
