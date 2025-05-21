using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class ReviewSearchObject : BaseSearchObject
    {
        public int? DoctorId { get; set; }
        public int? PatientId { get; set; }
        public int? AppointmentId { get; set; }
        public int? Rating { get; set; }
        public string? DoctorNameGTE { get; set; }
        public string? PatientNameGTE { get; set; }
        public DateTime? CreatedAfter { get; set; }
        public DateTime? CreatedBefore { get; set; }
        public bool isDeleted { get; set; }
    }
}
