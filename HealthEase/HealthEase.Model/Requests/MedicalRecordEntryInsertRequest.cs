using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class MedicalRecordEntryInsertRequest
    {
        public int MedicalRecordId { get; set; }
        public string EntryType { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int DoctorId { get; set; }
    }
}
