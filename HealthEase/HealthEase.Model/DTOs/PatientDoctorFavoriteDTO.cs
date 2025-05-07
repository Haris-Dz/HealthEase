using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class PatientDoctorFavoriteDTO
    {
        public int PatientId { get; set; }
        public int DoctorId { get; set; }
        public DoctorDTO Doctor { get; set; } = null!;
        public DateTime CreatedAt { get; set; }
    }
}
