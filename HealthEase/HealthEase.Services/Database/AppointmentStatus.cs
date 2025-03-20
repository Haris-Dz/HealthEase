using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class AppointmentStatus : BaseEntity
    {
        [Key]
        public int AppointmentStatusId { get; set; }
        [Required, MaxLength(100)]
        public string Status { get; set; } = null!;

        public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
    }
}
