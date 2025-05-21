using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Model.DTOs;
using HealthEase.Model.Exceptions;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace HealthEase.Services
{
    public class ReviewService : BaseCRUDServiceAsync<ReviewDTO, ReviewSearchObject, Review, ReviewInsertRequest, ReviewUpdateRequest>, IReviewService
    {
        public ReviewService(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Review> AddFilter(ReviewSearchObject search, IQueryable<Review> query)
        {

            if (search.DoctorId.HasValue)
                query = query.Where(r => r.Doctor.User.UserId == search.DoctorId.Value);

            if (search.PatientId.HasValue)
                query = query.Where(r => r.PatientId == search.PatientId.Value);

            if (search.AppointmentId.HasValue)
                query = query.Where(r => r.AppointmentId == search.AppointmentId.Value);

            if (search.Rating.HasValue)
                query = query.Where(r => r.Rating >= search.Rating.Value);

            if (!string.IsNullOrWhiteSpace(search.DoctorNameGTE))
                query = query.Where(r =>
                    (r.Doctor.User.FirstName + " " + r.Doctor.User.LastName).ToLower().Contains(search.DoctorNameGTE.ToLower())
                );

            if (!string.IsNullOrWhiteSpace(search.PatientNameGTE))
                query = query.Where(r =>
                    (r.Patient.FirstName + " " + r.Patient.LastName).ToLower().Contains(search.PatientNameGTE.ToLower())
                );

            if (search.CreatedAfter.HasValue)
                query = query.Where(r => r.CreatedAt >= search.CreatedAfter.Value);

            if (search.CreatedBefore.HasValue)
                query = query.Where(r => r.CreatedAt <= search.CreatedBefore.Value);

            if (search.isDeleted == true)
            {
                return query.Include(r => r.Doctor)
                        .ThenInclude(d => d.User)
                        .Include(r => r.Patient)
                        .Include(r => r.Appointment);
            }
            query = query.Where(r => !r.IsDeleted);

            return query.Include(r => r.Doctor)
                        .ThenInclude(d => d.User)
                        .Include(r => r.Patient)
                        .Include(r => r.Appointment);
        }

        public override async Task BeforeInsertAsync(ReviewInsertRequest request, Review entity, CancellationToken cancellationToken = default)
        {
            var appointment = await Context.Appointments
                .AsNoTracking()
                .FirstOrDefaultAsync(a => a.AppointmentId == request.AppointmentId, cancellationToken);

            if (appointment == null)
                throw new UserException("Appointment not found.");

            if (appointment.Status != "Paid" || appointment.AppointmentDate > DateTime.Now)
                throw new UserException("Review can only be left for paid and completed appointments.");

            var alreadyReviewed = await Context.Reviews
                .AnyAsync(r => r.AppointmentId == request.AppointmentId, cancellationToken);

            if (alreadyReviewed)
                throw new UserException("A review for this appointment already exists.");

            entity.DoctorId = appointment.DoctorId;
            entity.PatientId = appointment.PatientId;
            entity.AppointmentId = appointment.AppointmentId;

            entity.CreatedAt = DateTime.Now;
        }

    }
}
