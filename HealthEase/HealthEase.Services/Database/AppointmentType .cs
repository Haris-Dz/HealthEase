using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class AppointmentType : BaseEntity
    {
        [Key]
        public int AppointmentTypeId { get; set; }

        [Required]
        public string Name { get; set; } = null!;
        public decimal Price { get; set; }

        public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
    }
}
