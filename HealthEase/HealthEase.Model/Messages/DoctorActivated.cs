using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Messages
{
    public class DoctorActivated
    {
        public string customerFirstName { get; set; }
        public string customerLastName { get; set; }
        public string email { get; set; }
        public string doctorFirstName { get; set; }
        public string doctorLastName { get; set; }
        public string doctorSpecialization { get; set; }
    }
}
