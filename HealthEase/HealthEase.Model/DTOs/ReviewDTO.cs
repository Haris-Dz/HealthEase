using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class ReviewDTO
    {
        public int ReviewId { get; set; }
        public int DoctorId { get; set; }
        public int AppointmentId { get; set; }
        public int PatientId { get; set; }

        public int Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; }
        public string? DoctorName { get; set; } 
        public string? PatientName { get; set; } 
        public string? PatientProfilePicture { get; set; } 
        public bool IsDeleted { get; set; }
    }
}
