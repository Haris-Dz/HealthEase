using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class PatientDoctorSchedule : BaseEntity
    {
        [Key]
        public int PatientDoctorScheduleId { get; set; }

        [Required]
        public int PatientId { get; set; }
        [ForeignKey("PatientId")]
        public virtual Patient Patient { get; set; } = null!;

        [Required]
        public int DoctorId { get; set; }
        [ForeignKey("DoctorId")]
        public virtual Doctor Doctor { get; set; } = null!;

        [Required]
        public DateTime ScheduledDate { get; set; }
    }
}
