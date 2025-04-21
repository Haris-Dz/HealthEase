using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Specialization : BaseEntity
    {
        [Key]
        public int SpecializationId { get; set; }
        [MaxLength(100)]
        public string Name { get; set; } = null!;
        public string Description { get; set; } = null!;
        public virtual ICollection<DoctorSpecialization> DoctorSpecializations { get; set; } = new List<DoctorSpecialization>();
    }
}
