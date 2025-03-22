using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class PrescriptionStatus : BaseEntity
    {
        [Key]
        public int PrescriptionStatusId { get; set; }
        [MaxLength(100)]
        public string? Status { get; set; } 

        public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
    }
}
