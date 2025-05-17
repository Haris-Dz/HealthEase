using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class PatientSearchObject:BaseSearchObject
    {
        public string? FirstNameGTE { get; set; }

        public string? LastNameGTE { get; set; }

        public string? FirstLastNameGTE { get; set; }

        public string? EmailGTE { get; set; }

        public string? PhoneNumber { get; set; }

        public string? Username { get; set; }
        public string? UsernameGTE { get; set; }
    }
}
