using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class WorkingHoursDTO
    {
        public int WorkingHoursId { get; set; }
        public DayOfWeek Day { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
    }
}
