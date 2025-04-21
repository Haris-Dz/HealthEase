using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class DoctorDTO
    {
        public int DoctorId { get; set; }
        public int UserId { get; set; }
        public byte[]? ProfilePicture { get; set; }
        public string? Biography { get; set; }
        public string? Title { get; set; }
        public string? StateMachine { get; set; }

        //public virtual ICollection<DoctorSpecialization> DoctorSpecializations { get; set; } = new List<DoctorSpecialization>();
    }
}
