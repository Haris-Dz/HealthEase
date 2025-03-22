using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Doctor : BaseEntity
    {
        [Key]
        public int DoctorId { get; set; }
        [MaxLength(100)]
        public string Name { get; set; } = null!;
        public string Specialty { get; set; } = null!;

        public virtual ICollection<DoctorSpecialization> DoctorSpecializations { get; set; } = new List<DoctorSpecialization>();
        public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
        public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
        public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
    }
}
