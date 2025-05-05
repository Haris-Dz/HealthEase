using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class AppointmentSearchObject : BaseSearchObject
    {
        public int? PatientId { get; set; } 
        public int? DoctorId { get; set; } 
        public DateTime? AppointmentDate { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string? Status { get; set; }
    }
}
