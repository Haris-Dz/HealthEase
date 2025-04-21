using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class DoctorSearchObject:BaseSearchObject
    {
        public string? FirstNameGTE { get; set; }

        public string? LastNameGTE { get; set; }

        public string? FirstLastNameGTE { get; set; }

        public string? EmailGTE { get; set; }
        public List<int>? SpecializationIds { get; set; }
    }
}
