using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class DoctorSpecializationDTO
    {
        public int DoctorSpecializationId { get; set; }
        public int SpecializationId { get; set; }
        public string? SpecializationName { get; set; }
    }
}
