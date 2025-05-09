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
        public virtual DbSet<Doctor> Doctors { get; set; }
        public virtual DbSet<UserRole> UserRoles { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<Patient> Patients { get; set; }
        public virtual DbSet<Specialization> Specializations { get; set; }
        public virtual DbSet<Appointment> Appointments { get; set; }
        public virtual DbSet<AppointmentType> AppointmentTypes { get; set; }
        public virtual DbSet<MedicalRecord> MedicalRecords { get; set; }
        public virtual DbSet<Notification> Notifications { get; set; }
        public virtual DbSet<Payment> Payments { get; set; }
        public virtual DbSet<PaymentStatus> PaymentStatuses { get; set; }
        public virtual DbSet<Prescription> Prescriptions { get; set; }
        public virtual DbSet<PrescriptionStatus> PrescriptionStatuses { get; set; }
        public virtual DbSet<DoctorSpecialization> DoctorSpecializations { get; set; }
        public virtual DbSet<WorkingHours> WorkingHours { get; set; }
        public virtual DbSet<Review> Reviews { get; set; }
        public virtual DbSet<PatientDoctorFavorite> PatientDoctorFavorites { get; set; }
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

            modelBuilder.Entity<DoctorSpecialization>()
                .HasOne(ds => ds.Doctor)
                .WithMany(s => s.DoctorSpecializations)
                .HasForeignKey(ds => ds.DoctorId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<DoctorSpecialization>()
                .HasOne(ur => ur.Specialization)
                .WithMany(r => r.DoctorSpecializations)
                .HasForeignKey(ur => ur.SpecializationId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<AppointmentType>()
                .Property(x => x.Price)
                .HasPrecision(10, 2);

            modelBuilder.Entity<PatientDoctorFavorite>()
                .HasKey(x => new { x.PatientId, x.DoctorId });

            modelBuilder.Entity<PatientDoctorFavorite>()
                .HasOne(x => x.Patient)
                .WithMany()
                .HasForeignKey(x => x.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<PatientDoctorFavorite>()
                .HasOne(x => x.Doctor)
                .WithMany()
                .HasForeignKey(x => x.DoctorId)
                .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<Role>().HasData(
                new Role { RoleId = 1, RoleName = "Admin", Description= "Administrator with full access to settings, user permissions and platform operations.", IsDeleted = false },
                new Role { RoleId = 2, RoleName = "Doctor", Description = "Medical professional providing consultations and working with patients.", IsDeleted = false },
                new Role { RoleId = 3, RoleName = "Assistant", Description = "Supports doctors by managing appointments and assisting with patient coordination.", IsDeleted = false }
                );

            modelBuilder.Entity<User>().HasData(
                new User { UserId = 1, FirstName = "1", LastName = "1", Username = "1", Email = "1", PhoneNumber = "1", IsDeleted = false, PasswordSalt = "NHVv+8KhAiQqFlz7k1P53Q==", PasswordHash = "XVDI7NKoOCtMiSrKR1uSSGWvA7o=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 2, FirstName = "Admin", LastName = "Admin", Username = "admin", Email = "admin@mail.com", PhoneNumber = "000000000", IsDeleted = false, PasswordSalt = "c0MJh5XS8DYQtkJavp5lsA==", PasswordHash = "wSG+yBth9HCj0O1AdRBL+CJjtR4=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 3, FirstName = "Doctor1", LastName = "Doctor1", Username = "doctor1", Email = "doctor1@mail.com", PhoneNumber = "000000011", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 4, FirstName = "Doctor2", LastName = "Doctor2", Username = "doctor2", Email = "doctor2@mail.com", PhoneNumber = "000000031", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 5, FirstName = "Doctor3", LastName = "Doctor3", Username = "doctor3", Email = "doctor3@mail.com", PhoneNumber = "000000051", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 6, FirstName = "Doctor4", LastName = "Doctor4", Username = "doctor4", Email = "doctor4@mail.com", PhoneNumber = "000000061", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 7, FirstName = "Assistant", LastName = "Assistant", Username = "assistant", Email = "assistant@mail.com", PhoneNumber = "000000002", IsDeleted = false, PasswordSalt = "/gLAN9q37ktD4sUpWLjN1g==", PasswordHash = "3JVNj98T0GrBkWatJPLYoaIqBEA=" , ProfilePicture = new byte[] { 0x0 } }
                );
            modelBuilder.Entity<Patient>().HasData(
                new Patient { PatientId = 1, FirstName = "Patient", LastName = "Patient", Username = "patient", Email = "patient@mail.com", PhoneNumber = "000000003", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = true, PasswordSalt = "xJWRSHLNdETt+kIqCoBJFg==", PasswordHash = "O44iKOh/G//phQTcSDoD6bvVYJA=" },
                new Patient { PatientId = 2, FirstName = "Patient1", LastName = "Patient1", Username = "patient1", Email = "patient1@mail.com", PhoneNumber = "000000004", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = true, PasswordSalt = "0gXuSZgjHZnAhePy8gl7RQ==", PasswordHash = "Y5PY6ThpfFSmRPQxSSgEEUfSMDc=" },
                new Patient { PatientId = 3, FirstName = "Patient2", LastName = "Patient2", Username = "patient2", Email = "patient2@mail.com", PhoneNumber = "000000005", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = true, PasswordSalt = "+tA31RiJ9vyUd2Lgu5jgNQ==", PasswordHash = "qIpSzM06en3MCcODqz5q0JhtBJQ=" }
                );
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { UserRoleId = 1, RoleId = 1, UserId = 1, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 2, RoleId = 1, UserId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 3, RoleId = 2, UserId = 3, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 4, RoleId = 2, UserId = 4, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 5, RoleId = 2, UserId = 5, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 6, RoleId = 2, UserId = 6, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 7, RoleId = 3, UserId = 7, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false }
                );
            modelBuilder.Entity<WorkingHours>().HasData(
                new WorkingHours { WorkingHoursId = 1, Day = DayOfWeek.Monday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 3 },
                new WorkingHours { WorkingHoursId = 2, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 3 },
                new WorkingHours { WorkingHoursId = 3, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 3 },
                new WorkingHours { WorkingHoursId = 4, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 3 },
                new WorkingHours { WorkingHoursId = 5, Day = DayOfWeek.Friday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 3 },
                new WorkingHours { WorkingHoursId = 6, Day = DayOfWeek.Monday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 4 },
                new WorkingHours { WorkingHoursId = 7, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 4 },
                new WorkingHours { WorkingHoursId = 8, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 4 },
                new WorkingHours { WorkingHoursId = 9, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 4 },
                new WorkingHours { WorkingHoursId = 10, Day = DayOfWeek.Friday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 4 },
                new WorkingHours { WorkingHoursId = 11, Day = DayOfWeek.Monday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 5 },
                new WorkingHours { WorkingHoursId = 12, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 5 },
                new WorkingHours { WorkingHoursId = 13, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 5 },
                new WorkingHours { WorkingHoursId = 14, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 5 },
                new WorkingHours { WorkingHoursId = 15, Day = DayOfWeek.Friday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 5 },
                new WorkingHours { WorkingHoursId = 16, Day = DayOfWeek.Monday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 6 },
                new WorkingHours { WorkingHoursId = 17, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 6 },
                new WorkingHours { WorkingHoursId = 18, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 6 },
                new WorkingHours { WorkingHoursId = 19, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 6 },
                new WorkingHours { WorkingHoursId = 20, Day = DayOfWeek.Friday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 6 }
            );
            modelBuilder.Entity<Specialization>().HasData(
                new Specialization { SpecializationId = 1, Name = "Cardiology", Description = "Specializes in diagnosing and treating diseases of the cardiovascular system."},
                new Specialization { SpecializationId = 2, Name = "Dermatology",Description = "Focuses on the treatment of skin, hair, and nail disorders." },
                new Specialization { SpecializationId = 3, Name = "Pediatrics", Description = "Provides medical care for infants, children, and adolescents."},
                new Specialization { SpecializationId = 4, Name = "Neurology", Description = "Deals with disorders of the nervous system including the brain and spinal cord."}
            );
            modelBuilder.Entity<Doctor>().HasData(
                new Doctor { DoctorId = 1, UserId = 3, Biography = "Dr. Doctor1 is an experienced specialist in internal medicine. He has dedicated over 10 years to diagnosing and treating a wide range of chronic diseases, with a focus on patient-centered care and health education.", Title = "Dr. med.", StateMachine = "draft", IsDeleted = false},
                new Doctor { DoctorId = 2, UserId = 4, Biography = "Dr. Doctor2 is a double specialist in cardiology and neurology. With a strong academic background and clinical expertise, she combines knowledge from both fields to provide comprehensive diagnostic and treatment solutions.", Title = "Dr. sci. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 3, UserId = 5, Biography = "Dr. Doctor3 is a pediatrician with more than 7 years of experience in treating children of all ages. Known for a compassionate approach and excellent communication with both kids and parents.", Title = "Mr. sci. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 4, UserId = 6, Biography = "Dr. Doctor4 is a skilled dermatologist who has worked extensively with skin conditions ranging from acne to rare autoimmune diseases. She emphasizes early diagnosis and personalized treatment plans.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false }
            );

            modelBuilder.Entity<DoctorSpecialization>().HasData(
                new DoctorSpecialization { DoctorSpecializationId = 1, DoctorId = 1, SpecializationId = 1 },
                new DoctorSpecialization { DoctorSpecializationId = 2, DoctorId = 2, SpecializationId = 1 },
                new DoctorSpecialization { DoctorSpecializationId = 3, DoctorId = 2, SpecializationId = 2 },
                new DoctorSpecialization { DoctorSpecializationId = 4, DoctorId = 3, SpecializationId = 3 },
                new DoctorSpecialization { DoctorSpecializationId = 5, DoctorId = 4, SpecializationId = 4 }
            );
            modelBuilder.Entity<AppointmentType>().HasData(
                new AppointmentType { AppointmentTypeId = 1, Name = "General Checkup", Price = 50 },
                new AppointmentType { AppointmentTypeId = 2, Name = "Consultation", Price = 80 },
                new AppointmentType { AppointmentTypeId = 3, Name = "Examination", Price = 100 },
                new AppointmentType { AppointmentTypeId = 4, Name = "Follow-up", Price = 40 }
            );
            modelBuilder.Entity<Appointment>().HasData(
                new Appointment { AppointmentId = 1, AppointmentDate = new DateTime(2025, 7, 6), AppointmentTime = new TimeSpan(9, 0, 0), Status = "Pending", StatusMessage = null, Note = "Headache and dizziness", IsPaid = false, PaymentDate = null, DoctorId = 1, PatientId = 1, AppointmentTypeId = 1, IsDeleted = false },
                new Appointment { AppointmentId = 2, AppointmentDate = new DateTime(2025, 7, 7), AppointmentTime = new TimeSpan(11, 0, 0), Status = "Approved", StatusMessage = "See you on time", Note = "Routine check-up", IsPaid = false, PaymentDate = null, DoctorId = 2, PatientId = 2, AppointmentTypeId = 2, IsDeleted = false },
                new Appointment { AppointmentId = 3, AppointmentDate = new DateTime(2025, 7, 8), AppointmentTime = new TimeSpan(13, 0, 0), Status = "Paid", StatusMessage = "Confirmed and paid", Note = "Follow-up for lab results", IsPaid = true, PaymentDate = new DateTime(2025, 5, 2), DoctorId = 3, PatientId = 3, AppointmentTypeId = 4, IsDeleted = false },
                new Appointment { AppointmentId = 4, AppointmentDate = new DateTime(2025, 7, 10), AppointmentTime = new TimeSpan(10, 0, 0), Status = "Declined", StatusMessage = "Doctor unavailable on selected date", Note = "Skin irritation consultation", IsPaid = false, PaymentDate = null, DoctorId = 4, PatientId = 1, AppointmentTypeId = 3, IsDeleted = false },
                new Appointment { AppointmentId = 5, AppointmentDate = new DateTime(2025, 7, 12), AppointmentTime = new TimeSpan(14, 0, 0), Status = "Pending", StatusMessage = null, Note = "Consultation about recurring migraines", IsPaid = false, PaymentDate = null, DoctorId = 1, PatientId = 2, AppointmentTypeId = 2, IsDeleted = false }
            );


        }

    }
}