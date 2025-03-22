using HealthEase.Model;
using HealthEase.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.BaseServiceInterfaces
{
    public interface IService<TModel, TSearch> where TSearch : BaseSearchObject
    {
        public PagedResult<TModel> GetPaged(TSearch search);
        public TModel GetById(int id);
    }
}
