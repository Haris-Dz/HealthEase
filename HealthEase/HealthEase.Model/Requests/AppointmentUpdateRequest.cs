using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class AppointmentUpdateRequest
    {
        public DateTime? AppointmentDate { get; set; }
        public TimeSpan? AppointmentTime { get; set; }
        public string? Status { get; set; }
        public string? StatusMessage { get; set; }
        public bool? IsPaid { get; set; }
        public DateTime? PaymentDate { get; set; }
    }
}
