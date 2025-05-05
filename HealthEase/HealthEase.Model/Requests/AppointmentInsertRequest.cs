using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class AppointmentInsertRequest
    {
        [Required]
        public DateTime AppointmentDate { get; set; }

        [Required]
        public TimeSpan AppointmentTime { get; set; }
        public string? Note { get; set; }
        [Required]
        public int AppointmentTypeId { get; set; }

        [Required]
        public int DoctorId { get; set; } 

        [Required]
        public int PatientId { get; set; } 
    }
}
