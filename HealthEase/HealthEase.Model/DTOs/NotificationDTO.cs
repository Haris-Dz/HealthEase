using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class NotificationDTO
    {
        public int NotificationId { get; set; }

        public string? Message { get; set; }
        public DateTime? CreatedAt { get; set; }
        public bool IsRead { get; set; }

        public PatientDTO Patient { get; set; }
    }

}
