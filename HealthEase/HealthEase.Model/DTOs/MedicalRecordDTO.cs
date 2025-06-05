using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class MedicalRecordDTO
    {
        public int MedicalRecordId { get; set; }
        public int PatientId { get; set; }
        public string? Notes { get; set; }
        public List<MedicalRecordEntryDTO> Entries { get; set; } = new List<MedicalRecordEntryDTO>();
    }
}
