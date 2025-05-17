using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Messages
{
    public class RegisterMessage
    {
        public string employeeFirstName { get; set; }
        public string employeeLastName { get; set; }
        public string email { get; set; }
        public string username { get; set; }
        public string password { get; set; }
    }
}
