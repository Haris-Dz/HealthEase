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
        public virtual DbSet<Transaction> Transactions { get; set; }
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
            modelBuilder.Entity<Transaction>()
                .HasOne(t => t.Patient)
                .WithMany()
                .HasForeignKey(t => t.PatientId)
                .OnDelete(DeleteBehavior.Restrict); 

            modelBuilder.Entity<Transaction>()
                .HasOne(t => t.Appointment)
                .WithOne()
                .HasForeignKey<Transaction>(t => t.AppointmentId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Review>()
                .HasOne(x => x.Appointment)
                .WithMany()
                .HasForeignKey(x => x.AppointmentId)
                .OnDelete(DeleteBehavior.Restrict); 




            modelBuilder.Entity<Role>().HasData(
                new Role { RoleId = 1, RoleName = "Admin", Description= "Administrator with full access to settings, user permissions and platform operations.", IsDeleted = false },
                new Role { RoleId = 2, RoleName = "Doctor", Description = "Medical professional providing consultations and working with patients.", IsDeleted = false },
                new Role { RoleId = 3, RoleName = "Assistant", Description = "Supports doctors by managing appointments and assisting with patient coordination.", IsDeleted = false }
                );

            modelBuilder.Entity<User>().HasData(
                new User { UserId = 1, FirstName = "1", LastName = "1", Username = "1", Email = "1", PhoneNumber = "1", IsDeleted = false, PasswordSalt = "NHVv+8KhAiQqFlz7k1P53Q==", PasswordHash = "XVDI7NKoOCtMiSrKR1uSSGWvA7o=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 2, FirstName = "Admin", LastName = "Test", Username = "desktop", Email = "admin@mail.com", PhoneNumber = "000000000", IsDeleted = false, PasswordSalt = "c0MJh5XS8DYQtkJavp5lsA==", PasswordHash = "wSG+yBth9HCj0O1AdRBL+CJjtR4=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 3, FirstName = "Robert", LastName = "Trahan", Username = "doctor", Email = "robert.t@mail.com", PhoneNumber = "062543234", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 4, FirstName = "Paul", LastName = "Ulrey", Username = "doctor1", Email = "paul.u@mail.com", PhoneNumber = "062222333", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 5, FirstName = "James", LastName = "Lozano", Username = "doctor2", Email = "james.l@mail.com", PhoneNumber = "062958342", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 6, FirstName = "Helen", LastName = "Evans", Username = "doctor3", Email = "helen.e@mail.com", PhoneNumber = "062332123", IsDeleted = false, PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=", ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 7, Username = "james.s", FirstName = "James", LastName = "Smith", Email = "james.s@mail.com", PhoneNumber = "061222111", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 8, Username = "emma.j", FirstName = "Emma", LastName = "Johnson", Email = "emma.j@mail.com", PhoneNumber = "060111222", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 9, Username = "liam.w", FirstName = "Liam", LastName = "Williams", Email = "liam.w@mail.com", PhoneNumber = "065333444", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 10, Username = "olivia.b", FirstName = "Olivia", LastName = "Brown", Email = "olivia.b@mail.com", PhoneNumber = "064222333", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 11, Username = "mason.d", FirstName = "Mason", LastName = "Davis", Email = "mason.d@mail.com", PhoneNumber = "063444555", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 12, Username = "ava.m", FirstName = "Ava", LastName = "Miller", Email = "ava.m@mail.com", PhoneNumber = "062111999", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 13, Username = "lucas.g", FirstName = "Lucas", LastName = "Garcia", Email = "lucas.g@mail.com", PhoneNumber = "061555888", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 14, Username = "mia.r", FirstName = "Mia", LastName = "Rodriguez", Email = "mia.r@mail.com", PhoneNumber = "065777666", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 15, Username = "jack.m", FirstName = "Jack", LastName = "Martinez", Email = "jack.m@mail.com", PhoneNumber = "064888777", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 16, Username = "sophia.h", FirstName = "Sophia", LastName = "Hernandez", Email = "sophia.h@mail.com", PhoneNumber = "063666555", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 17, Username = "logan.l", FirstName = "Logan", LastName = "Lopez", Email = "logan.l@mail.com", PhoneNumber = "061999222", PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI", PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==", IsDeleted = false, ProfilePicture = new byte[] { 0x0 } },
                new User { UserId = 18, FirstName = "Sabrina", LastName = "Gallagher", Username = "assistant", Email = "sabrina.g@mail.com", PhoneNumber = "062532195", IsDeleted = false, PasswordSalt = "/gLAN9q37ktD4sUpWLjN1g==", PasswordHash = "3JVNj98T0GrBkWatJPLYoaIqBEA=" , ProfilePicture = new byte[] { 0x0 } }
                    );
            modelBuilder.Entity<Patient>().HasData(
                new Patient { PatientId = 1, FirstName = "Mark", LastName = "Brown", Username = "mobile", Email = "mark.b@mail.com", PhoneNumber = "062123456", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = true, PasswordSalt = "xJWRSHLNdETt+kIqCoBJFg==", PasswordHash = "O44iKOh/G//phQTcSDoD6bvVYJA=" },
                new Patient { PatientId = 2, FirstName = "Lena", LastName = "Burgess", Username = "lenab", Email = "lena.b@mail.com", PhoneNumber = "062111222", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = true, PasswordSalt = "0gXuSZgjHZnAhePy8gl7RQ==", PasswordHash = "Y5PY6ThpfFSmRPQxSSgEEUfSMDc=" },
                new Patient { PatientId = 3, FirstName = "Donald", LastName = "Foster", Username = "donaldf", Email = "donald.f@mail.com", PhoneNumber = "062345678", RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13), ProfilePicture = null, IsDeleted = false, isActive = true, PasswordSalt = "+tA31RiJ9vyUd2Lgu5jgNQ==", PasswordHash = "qIpSzM06en3MCcODqz5q0JhtBJQ=" }
                );
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { UserRoleId = 1, UserId = 3, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 2, UserId = 4, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 3, UserId = 5, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 4, UserId = 6, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 5, UserId = 7, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 6, UserId = 8, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 7, UserId = 9, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 8, UserId = 10, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 9, UserId = 11, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 10, UserId = 12, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41) , IsDeleted = false },
                new UserRole { UserRoleId = 11, UserId = 13, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 12, UserId = 14, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 13, UserId = 15, RoleId = 2, ChangeDate =  new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 14, UserId = 16, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 15, UserId = 17, RoleId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 16, UserId = 1, RoleId = 1, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 17, UserId = 18, RoleId = 3, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 18, UserId = 2, RoleId = 1, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false }
            );
            modelBuilder.Entity<WorkingHours>().HasData(
                // Doctor 1 (UserId = 3)
                new WorkingHours { WorkingHoursId = 1, Day = DayOfWeek.Monday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 3 },
                new WorkingHours { WorkingHoursId = 2, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 3 },
                new WorkingHours { WorkingHoursId = 3, Day = DayOfWeek.Friday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 3 },

                // Doctor 2 (UserId = 4)
                new WorkingHours { WorkingHoursId = 4, Day = DayOfWeek.Monday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(16, 0, 0), UserId = 4 },
                new WorkingHours { WorkingHoursId = 5, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(16, 0, 0), UserId = 4 },
                new WorkingHours { WorkingHoursId = 6, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(16, 0, 0), UserId = 4 },

                // Doctor 3 (UserId = 5)
                new WorkingHours { WorkingHoursId = 7, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 5 },
                new WorkingHours { WorkingHoursId = 8, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 5 },
                new WorkingHours { WorkingHoursId = 9, Day = DayOfWeek.Friday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 5 },

                // Doctor 4 (UserId = 6)
                new WorkingHours { WorkingHoursId = 10, Day = DayOfWeek.Monday, StartTime = new TimeSpan(10, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 6 },
                new WorkingHours { WorkingHoursId = 11, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(10, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 6 },
                new WorkingHours { WorkingHoursId = 12, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(10, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 6 },

                // Doctor 5 (UserId = 7)
                new WorkingHours { WorkingHoursId = 13, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 7 },
                new WorkingHours { WorkingHoursId = 14, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 7 },
                new WorkingHours { WorkingHoursId = 15, Day = DayOfWeek.Friday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 7 },

                // Doctor 6 (UserId = 8)
                new WorkingHours { WorkingHoursId = 16, Day = DayOfWeek.Monday, StartTime = new TimeSpan(12, 0, 0), EndTime = new TimeSpan(18, 0, 0), UserId = 8 },
                new WorkingHours { WorkingHoursId = 17, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(12, 0, 0), EndTime = new TimeSpan(18, 0, 0), UserId = 8 },
                new WorkingHours { WorkingHoursId = 18, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(12, 0, 0), EndTime = new TimeSpan(18, 0, 0), UserId = 8 },

                // Doctor 7 (UserId = 9)
                new WorkingHours { WorkingHoursId = 19, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 9 },
                new WorkingHours { WorkingHoursId = 20, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 9 },
                new WorkingHours { WorkingHoursId = 21, Day = DayOfWeek.Friday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 9 },

                // Doctor 8 (UserId = 10)
                new WorkingHours { WorkingHoursId = 22, Day = DayOfWeek.Monday, StartTime = new TimeSpan(7, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 10 },
                new WorkingHours { WorkingHoursId = 23, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(7, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 10 },
                new WorkingHours { WorkingHoursId = 24, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(7, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 10 },

                // Doctor 9 (UserId = 11)
                new WorkingHours { WorkingHoursId = 25, Day = DayOfWeek.Monday, StartTime = new TimeSpan(11, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 11 },
                new WorkingHours { WorkingHoursId = 26, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(11, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 11 },
                new WorkingHours { WorkingHoursId = 27, Day = DayOfWeek.Friday, StartTime = new TimeSpan(11, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 11 },

                // Doctor 10 (UserId = 12)
                new WorkingHours { WorkingHoursId = 28, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(13, 0, 0), EndTime = new TimeSpan(19, 0, 0), UserId = 12 },
                new WorkingHours { WorkingHoursId = 29, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(13, 0, 0), EndTime = new TimeSpan(19, 0, 0), UserId = 12 },
                new WorkingHours { WorkingHoursId = 30, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(13, 0, 0), EndTime = new TimeSpan(19, 0, 0), UserId = 12 },

                // Doctor 11 (UserId = 13)
                new WorkingHours { WorkingHoursId = 31, Day = DayOfWeek.Monday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 13 },
                new WorkingHours { WorkingHoursId = 32, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 13 },
                new WorkingHours { WorkingHoursId = 33, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 13 },

                // Doctor 12 (UserId = 14)
                new WorkingHours { WorkingHoursId = 34, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 14 },
                new WorkingHours { WorkingHoursId = 35, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 14 },
                new WorkingHours { WorkingHoursId = 36, Day = DayOfWeek.Friday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(14, 0, 0), UserId = 14 },

                // Doctor 13 (UserId = 15)
                new WorkingHours { WorkingHoursId = 37, Day = DayOfWeek.Monday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 15 },
                new WorkingHours { WorkingHoursId = 38, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 15 },
                new WorkingHours { WorkingHoursId = 39, Day = DayOfWeek.Friday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(15, 0, 0), UserId = 15 },

                // Doctor 14 (UserId = 16)
                new WorkingHours { WorkingHoursId = 40, Day = DayOfWeek.Tuesday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 16 },
                new WorkingHours { WorkingHoursId = 41, Day = DayOfWeek.Wednesday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 16 },
                new WorkingHours { WorkingHoursId = 42, Day = DayOfWeek.Friday, StartTime = new TimeSpan(9, 0, 0), EndTime = new TimeSpan(17, 0, 0), UserId = 16 },

                // Doctor 15 (UserId = 17)
                new WorkingHours { WorkingHoursId = 43, Day = DayOfWeek.Monday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(13, 0, 0), UserId = 17 },
                new WorkingHours { WorkingHoursId = 44, Day = DayOfWeek.Thursday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(13, 0, 0), UserId = 17 },
                new WorkingHours { WorkingHoursId = 45, Day = DayOfWeek.Friday, StartTime = new TimeSpan(8, 0, 0), EndTime = new TimeSpan(13, 0, 0), UserId = 17 }
            );


            modelBuilder.Entity<Specialization>().HasData(
                new Specialization { SpecializationId = 1, Name = "Cardiology", Description = "Specializes in diagnosing and treating diseases of the cardiovascular system."},
                new Specialization { SpecializationId = 2, Name = "Dermatology",Description = "Focuses on the treatment of skin, hair, and nail disorders." },
                new Specialization { SpecializationId = 3, Name = "Pediatrics", Description = "Provides medical care for infants, children, and adolescents."},
                new Specialization { SpecializationId = 4, Name = "Neurology", Description = "Deals with disorders of the nervous system including the brain and spinal cord."}
            );
            modelBuilder.Entity<Doctor>().HasData(
                new Doctor { DoctorId = 1, UserId = 3, Biography = "Expert in internal medicine with 10+ years of experience.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 2, UserId = 4, Biography = "Cardiologist and neurologist. Strong academic background.", Title = "Dr. sci. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 3, UserId = 5, Biography = "Pediatrician known for working with children and parents.", Title = "Mr. sci. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 4, UserId = 6, Biography = "Dermatologist with focus on autoimmune diseases.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 5, UserId = 7, Biography = "Renowned orthopedic surgeon with innovative approach.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 6, UserId = 8, Biography = "Ophthalmologist specialized in laser vision correction.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 7, UserId = 9, Biography = "ENT specialist, passionate about minimally invasive surgery.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 8, UserId = 10, Biography = "Experienced oncologist, published over 20 papers.", Title = "Dr. sci. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 9, UserId = 11, Biography = "Pulmonologist focusing on chronic lung diseases.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 10, UserId = 12, Biography = "Gastroenterologist with holistic patient approach.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 11, UserId = 13, Biography = "Endocrinologist, specialist for diabetes.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 12, UserId = 14, Biography = "General surgeon, expert in abdominal surgery.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 13, UserId = 15, Biography = "Psychiatrist with focus on youth mental health.", Title = "Dr. sci. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 14, UserId = 16, Biography = "Urologist, pioneer in new surgical techniques.", Title = "Dr. med.", StateMachine = "active", IsDeleted = false },
                new Doctor { DoctorId = 15, UserId = 17, Biography = "Rheumatologist passionate about research.", Title = "Dr. sci. med.", StateMachine = "active", IsDeleted = false }
            );


            modelBuilder.Entity<DoctorSpecialization>().HasData(
                new DoctorSpecialization { DoctorSpecializationId = 1, DoctorId = 1, SpecializationId = 1 }, 
                new DoctorSpecialization { DoctorSpecializationId = 2, DoctorId = 2, SpecializationId = 2 }, 
                new DoctorSpecialization { DoctorSpecializationId = 3, DoctorId = 3, SpecializationId = 3 }, 
                new DoctorSpecialization { DoctorSpecializationId = 4, DoctorId = 4, SpecializationId = 4 }, 
                new DoctorSpecialization { DoctorSpecializationId = 5, DoctorId = 5, SpecializationId = 2 }, 
                new DoctorSpecialization { DoctorSpecializationId = 6, DoctorId = 6, SpecializationId = 3 }, 
                new DoctorSpecialization { DoctorSpecializationId = 7, DoctorId = 7, SpecializationId = 1 }, 
                new DoctorSpecialization { DoctorSpecializationId = 8, DoctorId = 8, SpecializationId = 4 }, 
                new DoctorSpecialization { DoctorSpecializationId = 9, DoctorId = 9, SpecializationId = 2 }, 
                new DoctorSpecialization { DoctorSpecializationId = 10, DoctorId = 10, SpecializationId = 1 }, 
                new DoctorSpecialization { DoctorSpecializationId = 11, DoctorId = 11, SpecializationId = 3 }, 
                new DoctorSpecialization { DoctorSpecializationId = 12, DoctorId = 12, SpecializationId = 4 }, 
                new DoctorSpecialization { DoctorSpecializationId = 13, DoctorId = 13, SpecializationId = 1 }, 
                new DoctorSpecialization { DoctorSpecializationId = 14, DoctorId = 14, SpecializationId = 4 },
                new DoctorSpecialization { DoctorSpecializationId = 15, DoctorId = 15, SpecializationId = 3 } 
            );
            modelBuilder.Entity<AppointmentType>().HasData(
                new AppointmentType { AppointmentTypeId = 1, Name = "General Checkup", Price = 50 },
                new AppointmentType { AppointmentTypeId = 2, Name = "Consultation", Price = 80 },
                new AppointmentType { AppointmentTypeId = 3, Name = "Examination", Price = 100 },
                new AppointmentType { AppointmentTypeId = 4, Name = "Follow-up", Price = 40 }
            );
            modelBuilder.Entity<Appointment>().HasData(
                new Appointment { AppointmentId = 1, AppointmentDate = new DateTime(2025, 7, 7), AppointmentTime = new TimeSpan(9, 0, 0), Status = "Pending", StatusMessage = null, Note = "Headache and dizziness", IsPaid = false, PaymentDate = null, DoctorId = 1, PatientId = 1, AppointmentTypeId = 1, IsDeleted = false },
                new Appointment { AppointmentId = 2, AppointmentDate = new DateTime(2025, 7, 15), AppointmentTime = new TimeSpan(11, 0, 0), Status = "Approved", StatusMessage = "See you on time", Note = "Routine check-up", IsPaid = false, PaymentDate = null, DoctorId = 2, PatientId = 2, AppointmentTypeId = 2, IsDeleted = false },
                new Appointment { AppointmentId = 3, AppointmentDate = new DateTime(2025, 7, 10), AppointmentTime = new TimeSpan(11, 0, 0), Status = "Paid", StatusMessage = "Confirmed and paid", Note = "Follow-up for lab results", IsPaid = true, PaymentDate = new DateTime(2025, 5, 2), DoctorId = 3, PatientId = 3, AppointmentTypeId = 4, IsDeleted = false },
                new Appointment { AppointmentId = 4, AppointmentDate = new DateTime(2025, 7, 11), AppointmentTime = new TimeSpan(10, 0, 0), Status = "Declined", StatusMessage = "Doctor unavailable on selected date", Note = "Skin irritation consultation", IsPaid = false, PaymentDate = null, DoctorId = 4, PatientId = 1, AppointmentTypeId = 3, IsDeleted = false },
                new Appointment { AppointmentId = 5, AppointmentDate = new DateTime(2025, 7, 16), AppointmentTime = new TimeSpan(13, 0, 0), Status = "Pending", StatusMessage = null, Note = "Consultation about recurring migraines", IsPaid = false, PaymentDate = null, DoctorId = 1, PatientId = 2, AppointmentTypeId = 2, IsDeleted = false }
            );
            modelBuilder.Entity<PatientDoctorFavorite>().HasData(
                new PatientDoctorFavorite { PatientId = 1, DoctorId = 2, CreatedAt = new DateTime(2025, 5, 22, 8, 30, 0) },
                new PatientDoctorFavorite { PatientId = 1, DoctorId = 5, CreatedAt = new DateTime(2025, 5, 21, 14, 15, 0) },
                new PatientDoctorFavorite { PatientId = 1, DoctorId = 10, CreatedAt = new DateTime(2025, 5, 21, 15, 0, 0) },
                new PatientDoctorFavorite { PatientId = 2, DoctorId = 3, CreatedAt = new DateTime(2025, 5, 20, 9, 0, 0) },
                new PatientDoctorFavorite { PatientId = 2, DoctorId = 7, CreatedAt = new DateTime(2025, 5, 19, 11, 45, 0) },
                new PatientDoctorFavorite { PatientId = 2, DoctorId = 12, CreatedAt = new DateTime(2025, 5, 18, 17, 10, 0) },
                new PatientDoctorFavorite { PatientId = 3, DoctorId = 1, CreatedAt = new DateTime(2025, 5, 22, 9, 20, 0) },
                new PatientDoctorFavorite { PatientId = 3, DoctorId = 6, CreatedAt = new DateTime(2025, 5, 21, 10, 50, 0) },
                new PatientDoctorFavorite { PatientId = 3, DoctorId = 13, CreatedAt = new DateTime(2025, 5, 20, 13, 5, 0) },
                new PatientDoctorFavorite { PatientId = 2, DoctorId = 14, CreatedAt = new DateTime(2025, 5, 22, 16, 30, 0) }
            );






        }

    }
}