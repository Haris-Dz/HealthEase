using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Doctor : BaseEntity
    {
        [Key]
        public int DoctorId { get; set; }

        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        public byte[]? ProfilePicture { get; set; }
        public string? Biography { get; set; }
        public string? Title { get; set; }
        public string? StateMachine { get; set; }

        public virtual ICollection<DoctorSpecialization> DoctorSpecializations { get; set; } = new List<DoctorSpecialization>();

        public virtual ICollection<WorkingHours> WorkingHours { get; set; } = new List<WorkingHours>();
    }
}
