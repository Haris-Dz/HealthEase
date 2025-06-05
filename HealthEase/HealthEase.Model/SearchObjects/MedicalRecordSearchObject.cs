using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class MedicalRecordSearchObject : BaseSearchObject
    {
        public int? PatientId { get; set; }
        public string? PatientName { get; set; }
    }
}
