using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Model.DTOs.ReportsDTOs;
using HealthEase.Services.Database;
using Microsoft.EntityFrameworkCore;

namespace HealthEase.Services
{
    public class ReportService : IReportService
    {
        private readonly HealthEaseContext _context;

        public ReportService(HealthEaseContext context)
        {
            _context = context;
        }

        public async Task<AdminReportSummaryDTO> GetSummaryAsync(DateTime? startDate = null, DateTime? endDate = null)
        {
            // Filtering by date if needed (apply on appointments/transactions)
            var appointmentsQuery = _context.Appointments.AsQueryable();
            var transactionsQuery = _context.Transactions.AsQueryable();

            if (startDate.HasValue)
            {
                appointmentsQuery = appointmentsQuery.Where(a => a.AppointmentDate >= startDate.Value);
                transactionsQuery = transactionsQuery.Where(t => t.TransactionDate >= startDate.Value);
            }
            if (endDate.HasValue)
            {
                appointmentsQuery = appointmentsQuery.Where(a => a.AppointmentDate <= endDate.Value);
                transactionsQuery = transactionsQuery.Where(t => t.TransactionDate <= endDate.Value);
            }

            // Appointments
            var totalAppointments = await appointmentsQuery.CountAsync();
            var approvedAppointments = await appointmentsQuery.CountAsync(a => a.Status == "Approved");
            var declinedAppointments = await appointmentsQuery.CountAsync(a => a.Status == "Declined");
            var pendingAppointments = await appointmentsQuery.CountAsync(a => a.Status == "Pending");
            var paidAppointments = await appointmentsQuery.CountAsync(a => a.Status == "Paid");

            // Revenue (total and per month)
            var totalRevenue = await transactionsQuery.SumAsync(t => (decimal?)t.Amount) ?? 0;

            var revenuePerMonth = transactionsQuery
                .Where(t => t.TransactionDate != null)
                .GroupBy(t => new { Year = t.TransactionDate.Value.Year, Month = t.TransactionDate.Value.Month })
                .Select(g => new
                {
                    Year = g.Key.Year,
                    Month = g.Key.Month,
                    Revenue = g.Sum(x => x.Amount)
                })
                .AsEnumerable()
                .Select(x => new RevenuePerMonthDTO
                {
                    Month = $"{x.Year}-{x.Month:00}",
                    Revenue = (decimal)x.Revenue
                })
                .OrderBy(x => x.Month)
                .ToList();



            // Top 3 doctors by number of appointments
            var topDoctorsByAppointments = await appointmentsQuery
                .Where(a => a.DoctorId != null && a.Status == "Approved")
                .GroupBy(a => a.DoctorId)
                .Select(g => new
                {
                    DoctorId = g.Key,
                    AppointmentsCount = g.Count()
                })
                .OrderByDescending(x => x.AppointmentsCount)
                .Take(3)
                .ToListAsync();

            // Get doctor names for top 3 by appointments
            var doctorIdsByAppointments = topDoctorsByAppointments.Select(x => x.DoctorId).ToList();
            var doctorNamesDict = await _context.Doctors
                .Where(d => doctorIdsByAppointments.Contains(d.DoctorId))
                .Include(d => d.User)
                .ToDictionaryAsync(d => d.DoctorId, d => d.User.FirstName + " " + d.User.LastName);

            var topDoctorsByAppointmentsResult = topDoctorsByAppointments
                .Select(x => new TopDoctorDTO
                {
                    DoctorId = x.DoctorId,
                    Name = doctorNamesDict.ContainsKey(x.DoctorId) ? doctorNamesDict[x.DoctorId] : "",
                    AppointmentsCount = x.AppointmentsCount,
                    AverageRating = null // not used in this case
                })
                .ToList();

            // Top 3 doctors by average rating
            var topDoctorsByRating = await _context.Reviews
                .Where(r => r.DoctorId != null && r.Rating != null)
                .GroupBy(r => r.DoctorId)
                .Select(g => new
                {
                    DoctorId = g.Key,
                    AverageRating = (double?)g.Average(r => r.Rating),  // sada je nullable double
                    ReviewsCount = g.Count()
                })
                .Where(x => x.ReviewsCount > 0)
                .OrderByDescending(x => x.AverageRating)
                .Take(3)
                .ToListAsync();

            var doctorIdsByRating = topDoctorsByRating.Select(x => x.DoctorId).ToList();
            var doctorNamesDictRating = await _context.Doctors
                .Where(d => doctorIdsByRating.Contains(d.DoctorId))
                .Include(d => d.User)
                .ToDictionaryAsync(d => d.DoctorId, d => d.User.FirstName + " " + d.User.LastName);

            var topDoctorsByRatingResult = topDoctorsByRating
                .Select(x => new TopDoctorDTO
                {
                    DoctorId = x.DoctorId,
                    Name = doctorNamesDictRating.ContainsKey(x.DoctorId) ? doctorNamesDictRating[x.DoctorId] : "",
                    AppointmentsCount = 0,
                    AverageRating = Math.Round(x.AverageRating ?? 0, 2)

                })
                .ToList();

            // Reviews
            var totalReviews = await _context.Reviews.CountAsync(r => r.Rating != null);
            var averageDoctorRating = await _context.Reviews
                .Where(r => r.Rating != null)
                .AverageAsync(r => (double?)r.Rating) ?? 0;

            return new AdminReportSummaryDTO
            {
                // Appointments
                TotalAppointments = totalAppointments,
                ApprovedAppointments = approvedAppointments,
                DeclinedAppointments = declinedAppointments,
                PendingAppointments = pendingAppointments,
                PaidAppointments = paidAppointments,

                // Revenue
                TotalRevenue = totalRevenue,
                RevenuePerMonth = revenuePerMonth,

                // Top doctors
                TopDoctorsByAppointments = topDoctorsByAppointmentsResult,
                TopDoctorsByRating = topDoctorsByRatingResult,

                // Feedback
                TotalReviews = totalReviews,
                AverageDoctorRating = Math.Round(averageDoctorRating, 2)
            };
        }
    }
}
