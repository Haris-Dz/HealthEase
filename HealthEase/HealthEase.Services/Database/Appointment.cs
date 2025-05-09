﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Appointment : BaseEntity
    {
        [Key]
        public int AppointmentId { get; set; }

        [Required]
        public DateTime AppointmentDate { get; set; }

        [Required]
        public TimeSpan AppointmentTime { get; set; }

        public string Status { get; set; } = null!;

        public string? StatusMessage { get; set; }

        public string? Note { get; set; }

        public bool IsPaid { get; set; }

        public DateTime? PaymentDate { get; set; }

        public int DoctorId { get; set; }
        [ForeignKey("DoctorId")]
        public virtual Doctor Doctor { get; set; } = null!;

        public int PatientId { get; set; }
        [ForeignKey("PatientId")]
        public virtual Patient Patient { get; set; } = null!;
        public int AppointmentTypeId { get; set; }
        [ForeignKey("AppointmentTypeId")]
        public virtual AppointmentType AppointmentType { get; set; } = null!;
    }
}
