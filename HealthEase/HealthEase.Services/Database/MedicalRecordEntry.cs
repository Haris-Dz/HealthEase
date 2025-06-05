using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class MedicalRecordEntry : BaseEntity
    {
        public int MedicalRecordEntryId { get; set; }
        public int MedicalRecordId { get; set; }
        public string EntryType { get; set; } = "";
        public DateTime EntryDate { get; set; }
        public string Title { get; set; } = ""; 
        public string Description { get; set; } = "";
        public int DoctorId { get; set; }
        [ForeignKey("DoctorId")]
        public Doctor Doctor { get; set; } = null!;
    }
}
