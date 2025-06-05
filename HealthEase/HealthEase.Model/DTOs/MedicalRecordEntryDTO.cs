using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class MedicalRecordEntryDTO
    {
        public int MedicalRecordEntryId { get; set; }
        public int MedicalRecordId { get; set; }
        public string EntryType { get; set; } = "";
        public DateTime EntryDate { get; set; }
        public string Title { get; set; } = "";
        public string Description { get; set; } = "";
        public int DoctorId { get; set; }
    }
}
