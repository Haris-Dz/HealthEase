using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class AppointmentTypeDTO
    {
        public int AppointmentTypeId { get; set; }
        public string Name { get; set; } = null!;
        public decimal Price { get; set; }
    }
}
