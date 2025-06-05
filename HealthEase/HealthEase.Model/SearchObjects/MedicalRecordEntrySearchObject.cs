using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class MedicalRecordEntrySearchObject : BaseSearchObject
    {
        public int? MedicalRecordId { get; set; }
        public int? DoctorId { get; set; }
        public DateTime? EntryDateFrom { get; set; }
        public DateTime? EntryDateTo { get; set; }
        public string? EntryType { get; set; }
    }
}
