using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class DoctorDTO
    {
        public int DoctorId { get; set; }
        public int UserId { get; set; }
        public string? Biography { get; set; }
        public string? Title { get; set; }
        public string? StateMachine { get; set; }
        public UserDTO? User { get; set; }

        public virtual ICollection<SpecializationDTO> DoctorSpecializations { get; set; } = new List<SpecializationDTO>();
        public virtual ICollection<WorkingHoursDTO> WorkingHours { get; set; } = new List<WorkingHoursDTO>();

    }
}
