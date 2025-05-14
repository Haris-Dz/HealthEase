using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class TransactionDTO
    {
        public int TransactionId { get; set; }
        public double Amount { get; set; }
        public DateTime? TransactionDate { get; set; }
        public string? PaymentMethod { get; set; }
        public string? PaymentId { get; set; }
        public string? PayerId { get; set; }
        public int PatientId { get; set; }
        public virtual PatientDTO? Patient { get; set; } 
        public int AppointmentId { get; set; }
        public virtual AppointmentDTO? Appointment { get; set; } 
    }
}
