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
    public partial class PatientReview : BaseEntity
    {
        [Key]
        public int PatientReviewId { get; set; }
        public int PatientId { get; set; }
        [ForeignKey("PatientId")]
        public virtual Patient Patient { get; set; } = null!;
        public int DoctorId { get; set; }
        [ForeignKey("DoctorId")]
        public virtual Doctor Doctor { get; set; } = null!;
        [Range(1,5)]
        public int? Rating { get; set; } // 1-5 scale

        [MaxLength(500)]
        public string? Comment { get; set; }
    }
}
