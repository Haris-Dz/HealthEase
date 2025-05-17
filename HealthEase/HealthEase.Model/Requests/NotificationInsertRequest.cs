using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class NotificationInsertRequest
    {
        public int PatientId { get; set; }
        public string Message { get; set; } = string.Empty;
    }

}
