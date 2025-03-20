using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Review : BaseEntity
    {
        [Key]
        public int ReviewId { get; set; }

        [Required]
        public int DoctorId { get; set; }
        [ForeignKey("DoctorId")]
        public virtual Doctor Doctor { get; set; } = null!;

        [Required]
        public int PatientId { get; set; }
        [ForeignKey("PatientId")]
        public virtual Patient Patient { get; set; } = null!;

        [Required]
        public int Rating { get; set; } // rating 1 - 5
        [MaxLength(500)]
        public string? Comment { get; set; }
    }
}
