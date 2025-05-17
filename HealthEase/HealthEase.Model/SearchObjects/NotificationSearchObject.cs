using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class NotificationSearchObject:BaseSearchObject
    {
        public int? PatientId { get; set; }
        public bool? IsRead { get; set; }
        public string? UsernameGTE { get; set; }
    }
}
