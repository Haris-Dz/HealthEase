using Healthease.API.Controllers.BaseControllers;
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services;

namespace Healthease.API.Controllers
{
    public class TransactionController : BaseCRUDControllerAsync<TransactionDTO, TransactionSearchObject, TransactionInsertRequest, TransactionUpdateRequest>
    {
        public TransactionController(ITransactionService service) : base(service)
        {

        }
    }
}
