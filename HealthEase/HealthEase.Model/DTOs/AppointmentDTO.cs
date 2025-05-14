using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class AppointmentDTO
    {
        public int AppointmentId { get; set; }
        public DateTime AppointmentDate { get; set; }
        public TimeSpan AppointmentTime { get; set; }
        public string Status { get; set; } = null!;
        public string? StatusMessage { get; set; }
        public string? Note { get; set; }
        public bool IsPaid { get; set; }
        public DateTime? PaymentDate { get; set; }

        public int DoctorId { get; set; }
        public DoctorDTO? Doctor { get; set; }

        public int PatientId { get; set; }
        public PatientDTO? Patient { get; set; }
        public int AppointmentTypeId { get; set; }
        public virtual AppointmentTypeDTO? AppointmentType { get; set; } 
    }
}
