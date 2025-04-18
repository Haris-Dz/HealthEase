﻿// <auto-generated />
using System;
using HealthEase.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace HealthEase.Services.Migrations
{
    [DbContext(typeof(HealthEaseContext))]
    partial class HealthEaseContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "9.0.3")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("HealthEase.Services.Database.Appointment", b =>
                {
                    b.Property<int>("AppointmentId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("AppointmentId"));

                    b.Property<DateTime?>("AppointmentDate")
                        .HasColumnType("datetime2");

                    b.Property<int?>("AppointmentStatusId")
                        .HasColumnType("int");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("PatientId")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("AppointmentId");

                    b.HasIndex("AppointmentStatusId");

                    b.HasIndex("PatientId");

                    b.HasIndex("UserId");

                    b.ToTable("Appointments");
                });

            modelBuilder.Entity("HealthEase.Services.Database.AppointmentStatus", b =>
                {
                    b.Property<int>("AppointmentStatusId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("AppointmentStatusId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Status")
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("AppointmentStatusId");

                    b.ToTable("AppointmentStatuses");
                });

            modelBuilder.Entity("HealthEase.Services.Database.MedicalRecord", b =>
                {
                    b.Property<int>("MedicalRecordId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("MedicalRecordId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("HealthConditions")
                        .HasMaxLength(500)
                        .HasColumnType("nvarchar(500)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("PatientId")
                        .HasColumnType("int");

                    b.HasKey("MedicalRecordId");

                    b.HasIndex("PatientId");

                    b.ToTable("MedicalRecords");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Notification", b =>
                {
                    b.Property<int>("NotificationId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("NotificationId"));

                    b.Property<DateTime?>("CreatedAt")
                        .HasColumnType("datetime2");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Message")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("PatientId")
                        .HasColumnType("int");

                    b.HasKey("NotificationId");

                    b.HasIndex("PatientId");

                    b.ToTable("Notifications");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Patient", b =>
                {
                    b.Property<int>("PatientId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PatientId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PasswordSalt")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PhoneNumber")
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("ProfilePicture")
                        .HasColumnType("varbinary(max)");

                    b.Property<DateTime>("RegistrationDate")
                        .HasColumnType("datetime2");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<bool>("isActive")
                        .HasColumnType("bit");

                    b.HasKey("PatientId");

                    b.ToTable("Patients");

                    b.HasData(
                        new
                        {
                            PatientId = 1,
                            Email = "patient@mail.com",
                            FirstName = "Patient",
                            IsDeleted = false,
                            LastName = "Patient",
                            PasswordHash = "O44iKOh/G//phQTcSDoD6bvVYJA=",
                            PasswordSalt = "xJWRSHLNdETt+kIqCoBJFg==",
                            PhoneNumber = "000000003",
                            RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13, 0, DateTimeKind.Unspecified),
                            Username = "patient",
                            isActive = true
                        },
                        new
                        {
                            PatientId = 2,
                            Email = "patient1@mail.com",
                            FirstName = "Patient1",
                            IsDeleted = false,
                            LastName = "Patient1",
                            PasswordHash = "Y5PY6ThpfFSmRPQxSSgEEUfSMDc=",
                            PasswordSalt = "0gXuSZgjHZnAhePy8gl7RQ==",
                            PhoneNumber = "000000004",
                            RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13, 0, DateTimeKind.Unspecified),
                            Username = "patient1",
                            isActive = false
                        },
                        new
                        {
                            PatientId = 3,
                            Email = "patient2@mail.com",
                            FirstName = "Patient2",
                            IsDeleted = false,
                            LastName = "Patient2",
                            PasswordHash = "qIpSzM06en3MCcODqz5q0JhtBJQ=",
                            PasswordSalt = "+tA31RiJ9vyUd2Lgu5jgNQ==",
                            PhoneNumber = "000000005",
                            RegistrationDate = new DateTime(2025, 4, 14, 22, 13, 13, 0, DateTimeKind.Unspecified),
                            Username = "patient2",
                            isActive = true
                        });
                });

            modelBuilder.Entity("HealthEase.Services.Database.Payment", b =>
                {
                    b.Property<int>("PaymentId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PaymentId"));

                    b.Property<double?>("Amount")
                        .HasColumnType("float");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("PatientId")
                        .HasColumnType("int");

                    b.Property<DateTime?>("PaymentDate")
                        .HasColumnType("datetime2");

                    b.Property<int?>("PaymentStatusId")
                        .HasColumnType("int");

                    b.HasKey("PaymentId");

                    b.HasIndex("PatientId");

                    b.HasIndex("PaymentStatusId");

                    b.ToTable("Payments");
                });

            modelBuilder.Entity("HealthEase.Services.Database.PaymentStatus", b =>
                {
                    b.Property<int>("PaymentStatusId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PaymentStatusId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Status")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("PaymentStatusId");

                    b.ToTable("PaymentStatuses");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Prescription", b =>
                {
                    b.Property<int>("PrescriptionId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PrescriptionId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Dosage")
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int?>("MedicalRecordId")
                        .HasColumnType("int");

                    b.Property<string>("Medication")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("PatientId")
                        .HasColumnType("int");

                    b.Property<DateTime?>("PrescriptionDate")
                        .HasColumnType("datetime2");

                    b.Property<int?>("PrescriptionStatusId")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("PrescriptionId");

                    b.HasIndex("MedicalRecordId");

                    b.HasIndex("PatientId");

                    b.HasIndex("PrescriptionStatusId");

                    b.HasIndex("UserId");

                    b.ToTable("Prescriptions");
                });

            modelBuilder.Entity("HealthEase.Services.Database.PrescriptionStatus", b =>
                {
                    b.Property<int>("PrescriptionStatusId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PrescriptionStatusId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Status")
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("PrescriptionStatusId");

                    b.ToTable("PrescriptionStatuses");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Review", b =>
                {
                    b.Property<int>("ReviewId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ReviewId"));

                    b.Property<string>("Comment")
                        .HasMaxLength(500)
                        .HasColumnType("nvarchar(500)");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("PatientId")
                        .HasColumnType("int");

                    b.Property<int?>("Rating")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("ReviewId");

                    b.HasIndex("PatientId");

                    b.HasIndex("UserId");

                    b.ToTable("Reviews");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Role", b =>
                {
                    b.Property<int>("RoleId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("RoleId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Description")
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("RoleName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("RoleId");

                    b.ToTable("Roles");

                    b.HasData(
                        new
                        {
                            RoleId = 1,
                            Description = "Administrator with full access to settings, user permissions and platform operations.",
                            IsDeleted = false,
                            RoleName = "Admin"
                        },
                        new
                        {
                            RoleId = 2,
                            Description = "Medical professional providing consultations and working with patients.",
                            IsDeleted = false,
                            RoleName = "Doctor"
                        },
                        new
                        {
                            RoleId = 3,
                            Description = "Supports doctors by managing appointments and assisting with patient coordination.",
                            IsDeleted = false,
                            RoleName = "Assistant"
                        });
                });

            modelBuilder.Entity("HealthEase.Services.Database.Specialization", b =>
                {
                    b.Property<int>("SpecializationId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("SpecializationId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("SpecializationId");

                    b.ToTable("Specializations");

                    b.HasData(
                        new
                        {
                            SpecializationId = 1,
                            IsDeleted = false,
                            Name = "Cardiologist"
                        },
                        new
                        {
                            SpecializationId = 2,
                            IsDeleted = false,
                            Name = "Oncologists"
                        },
                        new
                        {
                            SpecializationId = 3,
                            IsDeleted = false,
                            Name = "Neurologist"
                        },
                        new
                        {
                            SpecializationId = 4,
                            IsDeleted = false,
                            Name = "Pediatrician"
                        },
                        new
                        {
                            SpecializationId = 5,
                            IsDeleted = false,
                            Name = "Psychiatrist"
                        },
                        new
                        {
                            SpecializationId = 6,
                            IsDeleted = false,
                            Name = "Chiropractor"
                        });
                });

            modelBuilder.Entity("HealthEase.Services.Database.User", b =>
                {
                    b.Property<int>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UserId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PasswordSalt")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PhoneNumber")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("UserId");

                    b.ToTable("Users");

                    b.HasData(
                        new
                        {
                            UserId = 1,
                            Email = "1",
                            FirstName = "1",
                            IsDeleted = false,
                            LastName = "1",
                            PasswordHash = "XVDI7NKoOCtMiSrKR1uSSGWvA7o=",
                            PasswordSalt = "NHVv+8KhAiQqFlz7k1P53Q==",
                            PhoneNumber = "1",
                            Username = "1"
                        },
                        new
                        {
                            UserId = 2,
                            Email = "admin@mail.com",
                            FirstName = "Admin",
                            IsDeleted = false,
                            LastName = "Admin",
                            PasswordHash = "wSG+yBth9HCj0O1AdRBL+CJjtR4=",
                            PasswordSalt = "c0MJh5XS8DYQtkJavp5lsA==",
                            PhoneNumber = "000000000",
                            Username = "admin"
                        },
                        new
                        {
                            UserId = 3,
                            Email = "doctor@mail.com",
                            FirstName = "Doctor",
                            IsDeleted = false,
                            LastName = "Doctor",
                            PasswordHash = "uAQkJu5IuKT3FArAvq4E5KbBzRI=",
                            PasswordSalt = "ppASfJlw8D6P+mNsl7bqMA==",
                            PhoneNumber = "000000001",
                            Username = "doctor"
                        },
                        new
                        {
                            UserId = 4,
                            Email = "assistant@mail.com",
                            FirstName = "Assistant",
                            IsDeleted = false,
                            LastName = "Assistant",
                            PasswordHash = "3JVNj98T0GrBkWatJPLYoaIqBEA=",
                            PasswordSalt = "/gLAN9q37ktD4sUpWLjN1g==",
                            PhoneNumber = "000000002",
                            Username = "assistant"
                        });
                });

            modelBuilder.Entity("HealthEase.Services.Database.UserRole", b =>
                {
                    b.Property<int>("UserRoleId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UserRoleId"));

                    b.Property<DateTime>("ChangeDate")
                        .HasColumnType("datetime2");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("RoleId")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("UserRoleId");

                    b.HasIndex("RoleId");

                    b.HasIndex("UserId");

                    b.ToTable("UserRoles");

                    b.HasData(
                        new
                        {
                            UserRoleId = 1,
                            ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified),
                            IsDeleted = false,
                            RoleId = 1,
                            UserId = 1
                        },
                        new
                        {
                            UserRoleId = 2,
                            ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified),
                            IsDeleted = false,
                            RoleId = 1,
                            UserId = 2
                        },
                        new
                        {
                            UserRoleId = 3,
                            ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified),
                            IsDeleted = false,
                            RoleId = 2,
                            UserId = 3
                        },
                        new
                        {
                            UserRoleId = 4,
                            ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified),
                            IsDeleted = false,
                            RoleId = 3,
                            UserId = 4
                        });
                });

            modelBuilder.Entity("HealthEase.Services.Database.Appointment", b =>
                {
                    b.HasOne("HealthEase.Services.Database.AppointmentStatus", null)
                        .WithMany("Appointments")
                        .HasForeignKey("AppointmentStatusId");

                    b.HasOne("HealthEase.Services.Database.Patient", "Patient")
                        .WithMany("Appointments")
                        .HasForeignKey("PatientId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("HealthEase.Services.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Patient");

                    b.Navigation("User");
                });

            modelBuilder.Entity("HealthEase.Services.Database.MedicalRecord", b =>
                {
                    b.HasOne("HealthEase.Services.Database.Patient", "Patient")
                        .WithMany("MedicalRecords")
                        .HasForeignKey("PatientId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Patient");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Notification", b =>
                {
                    b.HasOne("HealthEase.Services.Database.Patient", "Patient")
                        .WithMany()
                        .HasForeignKey("PatientId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Patient");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Payment", b =>
                {
                    b.HasOne("HealthEase.Services.Database.Patient", "Patient")
                        .WithMany()
                        .HasForeignKey("PatientId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("HealthEase.Services.Database.PaymentStatus", null)
                        .WithMany("Payments")
                        .HasForeignKey("PaymentStatusId");

                    b.Navigation("Patient");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Prescription", b =>
                {
                    b.HasOne("HealthEase.Services.Database.MedicalRecord", null)
                        .WithMany("Prescriptions")
                        .HasForeignKey("MedicalRecordId");

                    b.HasOne("HealthEase.Services.Database.Patient", "Patient")
                        .WithMany("Prescriptions")
                        .HasForeignKey("PatientId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("HealthEase.Services.Database.PrescriptionStatus", null)
                        .WithMany("Prescriptions")
                        .HasForeignKey("PrescriptionStatusId");

                    b.HasOne("HealthEase.Services.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Patient");

                    b.Navigation("User");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Review", b =>
                {
                    b.HasOne("HealthEase.Services.Database.Patient", "Patient")
                        .WithMany("Reviews")
                        .HasForeignKey("PatientId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("HealthEase.Services.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Patient");

                    b.Navigation("User");
                });

            modelBuilder.Entity("HealthEase.Services.Database.UserRole", b =>
                {
                    b.HasOne("HealthEase.Services.Database.Role", "Role")
                        .WithMany("UserRoles")
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("HealthEase.Services.Database.User", "User")
                        .WithMany("UserRoles")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Role");

                    b.Navigation("User");
                });

            modelBuilder.Entity("HealthEase.Services.Database.AppointmentStatus", b =>
                {
                    b.Navigation("Appointments");
                });

            modelBuilder.Entity("HealthEase.Services.Database.MedicalRecord", b =>
                {
                    b.Navigation("Prescriptions");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Patient", b =>
                {
                    b.Navigation("Appointments");

                    b.Navigation("MedicalRecords");

                    b.Navigation("Prescriptions");

                    b.Navigation("Reviews");
                });

            modelBuilder.Entity("HealthEase.Services.Database.PaymentStatus", b =>
                {
                    b.Navigation("Payments");
                });

            modelBuilder.Entity("HealthEase.Services.Database.PrescriptionStatus", b =>
                {
                    b.Navigation("Prescriptions");
                });

            modelBuilder.Entity("HealthEase.Services.Database.Role", b =>
                {
                    b.Navigation("UserRoles");
                });

            modelBuilder.Entity("HealthEase.Services.Database.User", b =>
                {
                    b.Navigation("UserRoles");
                });
#pragma warning restore 612, 618
        }
    }
}
