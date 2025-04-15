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

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.User)
                .WithMany(u => u.UserRoles)
                .HasForeignKey(ur => ur.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.Role)
                .WithMany(r => r.UserRoles)
                .HasForeignKey(ur => ur.RoleId)
                .OnDelete(DeleteBehavior.Cascade);

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
                new User { UserId = 2, FirstName = "Admin", LastName = "Admin", Username = "admin", Email = "admin@mail.com", PhoneNumber = "000000000", IsDeleted = false, PasswordSalt = "c0MJh5XS8DYQtkJavp5lsA==", PasswordHash = "wSG+yBth9HCj0O1AdRBL+CJjtR4=" },
                new User { UserId = 3, FirstName = "Doctor", LastName = "Doctor", Username = "doctor", Email = "doctor@mail.com", PhoneNumber = "000000001", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=" },
                new User { UserId = 4, FirstName = "Assistant", LastName = "Assistant", Username = "assistant", Email = "assistant@mail.com", PhoneNumber = "000000002", IsDeleted = false, PasswordSalt = "/gLAN9q37ktD4sUpWLjN1g==", PasswordHash = "3JVNj98T0GrBkWatJPLYoaIqBEA=" }
                );
            modelBuilder.Entity<Patient>().HasData(
                new Patient { PatientId = 1, FirstName = "Patient", LastName = "Patient", Username = "patient", Email = "patient@mail.com", PhoneNumber = "000000003", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = true, PasswordSalt = "xJWRSHLNdETt+kIqCoBJFg==", PasswordHash = "O44iKOh/G//phQTcSDoD6bvVYJA=" },
                new Patient { PatientId = 2, FirstName = "Patient1", LastName = "Patient1", Username = "patient1", Email = "patient1@mail.com", PhoneNumber = "000000004", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = false, PasswordSalt = "0gXuSZgjHZnAhePy8gl7RQ==", PasswordHash = "Y5PY6ThpfFSmRPQxSSgEEUfSMDc=" },
                new Patient { PatientId = 3, FirstName = "Patient2", LastName = "Patient2", Username = "patient2", Email = "patient2@mail.com", PhoneNumber = "000000005", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = true, PasswordSalt = "+tA31RiJ9vyUd2Lgu5jgNQ==", PasswordHash = "qIpSzM06en3MCcODqz5q0JhtBJQ=" }
                );
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { UserRoleId = 1, RoleId = 1, UserId = 1, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 2, RoleId = 1, UserId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 3, RoleId = 2, UserId = 3, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 4, RoleId = 3, UserId = 4, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false }
                );

        }

    }
}