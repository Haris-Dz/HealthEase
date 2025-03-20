using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Patient : BaseEntity
    {
        [Key]
        public int PatientId { get; set; }
        [Required, MaxLength(100)]
        public string Name { get; set; } = null!;
        [Required, EmailAddress]
        public string Email { get; set; } = null!;

        public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
        public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
        public virtual ICollection<MedicalRecord> MedicalRecords { get; set; } = new List<MedicalRecord>();
        public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
    }
}
