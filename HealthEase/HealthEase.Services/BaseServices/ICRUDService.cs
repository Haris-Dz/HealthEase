using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServiceInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.BaseServices
{
    public interface ICRUDService<TModel, TSearch, TInsert, TUpdate> : IService<TModel, TSearch> where TModel : class where TSearch : BaseSearchObject
    {
        TModel Insert(TInsert request);
        TModel Update(int id, TUpdate request);
        void Delete(int id);
    }
}
