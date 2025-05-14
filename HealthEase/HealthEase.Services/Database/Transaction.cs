using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Transaction : BaseEntity
    {
        [Key]
        public int TransactionId { get; set; }
        public double Amount { get; set; }
        public DateTime? TransactionDate { get; set; }
        public string? PaymentMethod { get; set; } 
        public string? PaymentId { get; set; } 
        public string? PayerId { get; set; } 
        public int PatientId { get; set; }
        [ForeignKey("PatientId")]
        public virtual Patient Patient { get; set; } = null!;
        public int AppointmentId { get; set; }
        [ForeignKey("AppointmentId")]
        public virtual Appointment Appointment { get; set; } = null!;

    }
}
