using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs.ReportsDTOs
{
    public class AdminReportSummaryDTO
    {
        // Appointments
        public int TotalAppointments { get; set; }
        public int ApprovedAppointments { get; set; }
        public int DeclinedAppointments { get; set; }
        public int PendingAppointments { get; set; }
        public int PaidAppointments { get; set; }

        // Revenue
        public decimal TotalRevenue { get; set; }
        public List<RevenuePerMonthDTO> RevenuePerMonth { get; set; } = new List<RevenuePerMonthDTO>();

        // Top Doctors
        public List<TopDoctorDTO> TopDoctorsByAppointments { get; set; } = new List<TopDoctorDTO>();
        public List<TopDoctorDTO> TopDoctorsByRating { get; set; } = new List<TopDoctorDTO>();


        // Feedback
        public int TotalReviews { get; set; }
        public double AverageDoctorRating { get; set; }
    }
    public class RevenuePerMonthDTO
    {
        public string Month { get; set; } = string.Empty;
        public decimal Revenue { get; set; }
    }

    public class TopDoctorDTO
    {
        public int DoctorId { get; set; }
        public string Name { get; set; } = string.Empty;
        public int AppointmentsCount { get; set; }
        public double? AverageRating { get; set; }
    }
}
