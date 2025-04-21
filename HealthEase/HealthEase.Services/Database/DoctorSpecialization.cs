using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class DoctorSpecialization:BaseEntity
    {
        [Key]
        public int DoctorSpecializationId { get; set; }
        [ForeignKey(nameof(Doctor))]
        public int DoctorId { get; set; }
        public Doctor Doctor { get; set; } = null!;
        [ForeignKey(nameof(Specialization))]
        public int SpecializationId { get; set; }
        public Specialization Specialization { get; set; } = null!;
    }
}
