using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class DoctorSpecializationUpsertRequest
    {
        public int? DoctorSpecializationId { get; set; }
        public int? SpecializationId { get; set; }
    }
}
