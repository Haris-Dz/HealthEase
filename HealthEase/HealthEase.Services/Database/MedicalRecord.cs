using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class MedicalRecord : BaseEntity
    {
        [Key]
        public int MedicalRecordId { get; set; }
        [Required]
        public int PatientId { get; set; }
        [ForeignKey("PatientId")]
        public virtual Patient Patient { get; set; } = null!;

        [MaxLength(500)]
        public string? HealthConditions { get; set; }

        public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
    }
}
