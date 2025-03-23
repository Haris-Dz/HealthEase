using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using static System.Net.Mime.MediaTypeNames;

namespace HealthEase.Services.Database
{
    public partial class HealthEaseContext : DbContext
    {
        public HealthEaseContext() { }

        public HealthEaseContext(DbContextOptions<HealthEaseContext> options) : base(options) { }

        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<UserRole> UserRoles { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<Patient> Patients { get; set; }
        public virtual DbSet<Specialization> Specializations { get; set; }
        public virtual DbSet<Appointment> Appointments { get; set; }
        public virtual DbSet<AppointmentStatus> AppointmentStatuses { get; set; }
        public virtual DbSet<MedicalRecord> MedicalRecords { get; set; }
        public virtual DbSet<Notification> Notifications { get; set; }
        public virtual DbSet<Payment> Payments { get; set; }
        public virtual DbSet<PaymentStatus> PaymentStatuses { get; set; }
        public virtual DbSet<Prescription> Prescriptions { get; set; }
        public virtual DbSet<PrescriptionStatus> PrescriptionStatuses { get; set; }
        public virtual DbSet<Review> Reviews { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            modelBuilder.Entity<Specialization>().HasData(
                new Specialization { SpecializationId = 1, Name = "Cardiologist", IsDeleted = false},
                new Specialization { SpecializationId = 2, Name = "Oncologists", IsDeleted = false },
                new Specialization { SpecializationId = 3, Name = "Neurologist", IsDeleted = false },
                new Specialization { SpecializationId = 4, Name = "Pediatrician", IsDeleted = false },
                new Specialization { SpecializationId = 5, Name = "Psychiatrist", IsDeleted = false },
                new Specialization { SpecializationId = 6, Name = "Chiropractor", IsDeleted = false }
                );
            modelBuilder.Entity<Role>().HasData(
                new Role { RoleId = 1, RoleName = "Admin", Description= "Administrator with full access to settings, user permissions and platform operations.", IsDeleted = false },
                new Role { RoleId = 2, RoleName = "Doctor", Description = "Medical professional providing consultations and working with patients.", IsDeleted = false },
                new Role { RoleId = 3, RoleName = "Assistant", Description = "Supports doctors by managing appointments and assisting with patient coordination.", IsDeleted = false }
                );
            modelBuilder.Entity<User>().HasData(
                new User { UserId = 1, FirstName = "1", LastName = "1", Username = "1", Email = "1", PhoneNumber = "1", IsDeleted = false, PasswordSalt = "NHVv+8KhAiQqFlz7k1P53Q==", PasswordHash = "XVDI7NKoOCtMiSrKR1uSSGWvA7o=" },
                new User { UserId = 2, FirstName = "Admin", LastName = "Admin", Username = "admin", Email = "admin@mail.com", PhoneNumber = "000000000", IsDeleted = false, PasswordSalt = "BAbir1GLAnT8mlkl48K82Q==", PasswordHash = "vjxFUddajZn+mD4TXhrpKJFpwCk=" },
                new User { UserId = 3, FirstName = "Doctor", LastName = "Doctor", Username = "doctor", Email = "doctor@mail.com", PhoneNumber = "000000001", IsDeleted = false, PasswordSalt = "8am+nUzj04mmtBMFrnDslw==", PasswordHash = "pfDtnGt/IRu/L9EaFAjdfv0ngwk=" },
                new User { UserId = 4, FirstName = "Assistant", LastName = "Assistant", Username = "assistant", Email = "assistant@mail.com", PhoneNumber = "000000002", IsDeleted = false, PasswordSalt = "fQs/0a4aqARNG/avZ7mRlg==", PasswordHash = "1bwUDDXJ0XBRKYVYycBm+yVzUlQ=" }
                );
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { UserRoleId = 1,RoleId=1,UserId=1,ChangeDate= DateTime.Parse("2025-03-23 22:48:41.913"), IsDeleted = false },
                new UserRole { UserRoleId = 2, RoleId = 1, UserId = 2, ChangeDate = DateTime.Parse("2025-03-23 22:48:41.913"), IsDeleted = false },
                new UserRole { UserRoleId = 3, RoleId = 2, UserId = 3, ChangeDate = DateTime.Parse("2025-03-23 22:48:41.913"), IsDeleted = false },
                new UserRole { UserRoleId = 4, RoleId = 3, UserId = 4, ChangeDate = DateTime.Parse("2025-03-23 22:48:41.913"), IsDeleted = false }
                );

        }

    }
}