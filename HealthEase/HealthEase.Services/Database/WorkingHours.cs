using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class WorkingHours : BaseEntity
    {
        [Key]
        public int WorkingHoursId { get; set; }

        public int UserId { get; set; }
        [ForeignKey(("UserId"))]
        public virtual User User { get; set; } = null!;

        public DayOfWeek Day { get; set; }

        public TimeSpan? StartTime { get; set; }
        public TimeSpan? EndTime { get; set; }
    }

}
