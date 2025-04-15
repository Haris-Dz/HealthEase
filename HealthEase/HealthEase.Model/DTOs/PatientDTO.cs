using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class PatientDTO
    {
        public int PatientId { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string? PhoneNumber { get; set; }
        public byte[]? ProfilePicture { get; set; }
        public DateTime RegistrationDate { get; set; }
        public bool isActive { get; set; }
        public bool IsDeleted { get; set; }
        //public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
        //public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
        //public virtual ICollection<MedicalRecord> MedicalRecords { get; set; } = new List<MedicalRecord>();
        //public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
    }
}
