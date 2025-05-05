using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class AppointmentTypeUpsertRequest
    {
        public string Name { get; set; } = null!;
        public decimal Price { get; set; }
    }
}
