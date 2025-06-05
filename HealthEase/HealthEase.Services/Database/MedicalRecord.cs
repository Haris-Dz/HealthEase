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
        public int MedicalRecordId { get; set; }
        public int PatientId { get; set; }
        [ForeignKey("PatientId")]
        public virtual Patient Patient { get; set; } = null!;
        public string? Notes { get; set; }
        public virtual List<MedicalRecordEntry> Entries { get; set; } = new List<MedicalRecordEntry>();
    }
}
