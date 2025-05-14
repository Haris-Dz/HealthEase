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
    public class TransactionService : BaseCRUDServiceAsync<TransactionDTO, TransactionSearchObject, Transaction, TransactionInsertRequest, TransactionUpdateRequest>, ITransactionService
    {
        public TransactionService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Transaction> AddFilter(TransactionSearchObject search, IQueryable<Transaction> query)
        {
            if(search.PatientId.HasValue && search.PatientId>0)
            {
                query = query.Where(x => x. PatientId == search.PatientId);
            }

            if (search.DateFrom.HasValue)
            {
                query = query.Where(x => x.TransactionDate >= search.DateFrom.Value);
            }

            if (search.DateTo.HasValue)
            {
                query = query.Where(x => x.TransactionDate <= search.DateTo.Value);
            }
            if (!string.IsNullOrWhiteSpace(search?.PatientName))
            {
                query = query.Where(x => x.Patient.FirstName.StartsWith(search.PatientName));
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
        public override IQueryable<Transaction> AddInclude(IQueryable<Transaction> query)
        {
            return query
                .Include(x => x.Patient)
                .Include(x => x.Appointment)
                    .ThenInclude(a => a.Doctor)
                        .ThenInclude(d => d.User)
                .Include(x => x.Appointment)
                    .ThenInclude(a => a.Patient)
                .Include(x => x.Appointment)
                    .ThenInclude(a => a.AppointmentType);
        }

        public override async Task BeforeInsertAsync(TransactionInsertRequest request, Transaction entity, CancellationToken cancellationToken = default)
        {
            entity.TransactionDate = DateTime.Now;
        }

    }
}
