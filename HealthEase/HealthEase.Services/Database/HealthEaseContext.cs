using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class HealthEaseContext : DbContext
    {
        public HealthEaseContext() { }

        public HealthEaseContext(DbContextOptions<HealthEaseContext> options) : base(options) { }

        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Doctor> Doctors { get; set; }
        public virtual DbSet<Specialization> Specializations { get; set; }
        public virtual DbSet<Patient> Patients { get; set; }
        public virtual DbSet<Appointment> Appointments { get; set; }
        public virtual DbSet<MedicalRecord> MedicalRecords { get; set; }
        public virtual DbSet<Prescription> Prescriptions { get; set; }
        public virtual DbSet<Review> Reviews { get; set; }
        public virtual DbSet<Notification> Notifications { get; set; }
        public virtual DbSet<Payment> Payments { get; set; }
        public virtual DbSet<DoctorSpecialization> DoctorSpecializations { get; set; }

    }
}
