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

    public class AppointmentService : BaseCRUDServiceAsync<AppointmentDTO, AppointmentSearchObject, Appointment, AppointmentInsertRequest, AppointmentUpdateRequest>, IAppointmentService
    {
        private readonly ITransactionService _transactionService;
        public AppointmentService(HealthEaseContext context, IMapper mapper, ITransactionService transactionService) : base(context, mapper)
        {
            _transactionService = transactionService;
        }
        public override IQueryable<Appointment> AddFilter(AppointmentSearchObject search, IQueryable<Appointment> query)
        {
            if (search.PatientId.HasValue)
                query = query.Where(x => x.PatientId == search.PatientId.Value);

            if (search.DoctorId.HasValue)
                query = query.Where(x => x.DoctorId == search.DoctorId.Value);

            if (search.AppointmentDate.HasValue)
                query = query.Where(x => x.AppointmentDate.Date == search.AppointmentDate.Value.Date);

            if (search.DateFrom.HasValue)
                query = query.Where(x => x.AppointmentDate >= search.DateFrom.Value);

            if (search.DateTo.HasValue)
                query = query.Where(x => x.AppointmentDate <= search.DateTo.Value);

            if (!string.IsNullOrWhiteSpace(search.Status))
                query = query.Where(x => x.Status.ToLower() == search.Status.ToLower());
            return query;
        }
        public override IQueryable<Appointment> AddInclude(IQueryable<Appointment> query)
        {
            return query
                .Include(x => x.Doctor)
                    .ThenInclude(d => d.User)
                .Include(x => x.Patient)
                .Include(x=>x.AppointmentType);
        }
        public override async Task BeforeInsertAsync(AppointmentInsertRequest request, Appointment entity, CancellationToken cancellationToken = default)
        {
            entity.Status = "Pending";
            entity.IsPaid = false;
        }
        public override async Task BeforeUpdateAsync(AppointmentUpdateRequest request, Appointment entity, CancellationToken cancellationToken = default)
        {
            if (request.Approve.HasValue)
            {
                entity.Status = request.Approve.Value ? "Approved" : "Declined";
            }
            if (request.IsPaid == true)
            {
                entity.Status = "Paid";
            }
            if (request.TransactionInsert != null)
            {
                var existingTransaction = await Context.Transactions
                    .FirstOrDefaultAsync(t => t.AppointmentId == request.TransactionInsert.AppointmentId, cancellationToken);

                if (existingTransaction == null)
                {
                    await _transactionService.InsertAsync(request.TransactionInsert, cancellationToken);
                }
            }
        }

    }
}
