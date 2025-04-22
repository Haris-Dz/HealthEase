using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class WorkingHoursUpsertRequest
    {

        public int UserId { get; set; }
        public DayOfWeek Day { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
    }
}
