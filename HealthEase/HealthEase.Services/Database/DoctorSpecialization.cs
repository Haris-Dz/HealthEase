using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class DoctorSpecialization : BaseEntity
    {
        [Key]
        public int DoctorSpecializationId { get; set; }
        public int DoctorId { get; set; }
        [ForeignKey("DoctorId")]
        public virtual Doctor Doctor { get; set; } = null!;
        public int SpecializationId { get; set; }
        [ForeignKey("SpecializationId")]
        public virtual Specialization Specialization { get; set; } = null!;
    }
}
