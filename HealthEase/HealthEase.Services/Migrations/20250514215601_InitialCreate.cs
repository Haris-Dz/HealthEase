using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace HealthEase.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AppointmentTypes",
                columns: table => new
                {
                    AppointmentTypeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Price = table.Column<decimal>(type: "decimal(10,2)", precision: 10, scale: 2, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppointmentTypes", x => x.AppointmentTypeId);
                });

            migrationBuilder.CreateTable(
                name: "Patients",
                columns: table => new
                {
                    PatientId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Username = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FirstName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ProfilePicture = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    RegistrationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    isActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Patients", x => x.PatientId);
                });

            migrationBuilder.CreateTable(
                name: "PrescriptionStatuses",
                columns: table => new
                {
                    PrescriptionStatusId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Status = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PrescriptionStatuses", x => x.PrescriptionStatusId);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    RoleId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RoleName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.RoleId);
                });

            migrationBuilder.CreateTable(
                name: "Specializations",
                columns: table => new
                {
                    SpecializationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Specializations", x => x.SpecializationId);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Username = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FirstName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ProfilePicture = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserId);
                });

            migrationBuilder.CreateTable(
                name: "MedicalRecords",
                columns: table => new
                {
                    MedicalRecordId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PatientId = table.Column<int>(type: "int", nullable: false),
                    HealthConditions = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MedicalRecords", x => x.MedicalRecordId);
                    table.ForeignKey(
                        name: "FK_MedicalRecords_Patients_PatientId",
                        column: x => x.PatientId,
                        principalTable: "Patients",
                        principalColumn: "PatientId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    NotificationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PatientId = table.Column<int>(type: "int", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.NotificationId);
                    table.ForeignKey(
                        name: "FK_Notifications_Patients_PatientId",
                        column: x => x.PatientId,
                        principalTable: "Patients",
                        principalColumn: "PatientId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Doctors",
                columns: table => new
                {
                    DoctorId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Biography = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Doctors", x => x.DoctorId);
                    table.ForeignKey(
                        name: "FK_Doctors_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reviews",
                columns: table => new
                {
                    ReviewId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    PatientId = table.Column<int>(type: "int", nullable: false),
                    Rating = table.Column<int>(type: "int", nullable: true),
                    Comment = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reviews", x => x.ReviewId);
                    table.ForeignKey(
                        name: "FK_Reviews_Patients_PatientId",
                        column: x => x.PatientId,
                        principalTable: "Patients",
                        principalColumn: "PatientId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Reviews_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                columns: table => new
                {
                    UserRoleId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    ChangeDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRoles", x => x.UserRoleId);
                    table.ForeignKey(
                        name: "FK_UserRoles_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "RoleId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserRoles_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "WorkingHours",
                columns: table => new
                {
                    WorkingHoursId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Day = table.Column<int>(type: "int", nullable: false),
                    StartTime = table.Column<TimeSpan>(type: "time", nullable: true),
                    EndTime = table.Column<TimeSpan>(type: "time", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkingHours", x => x.WorkingHoursId);
                    table.ForeignKey(
                        name: "FK_WorkingHours_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Prescriptions",
                columns: table => new
                {
                    PrescriptionId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    PatientId = table.Column<int>(type: "int", nullable: false),
                    Medication = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Dosage = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PrescriptionDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    MedicalRecordId = table.Column<int>(type: "int", nullable: true),
                    PrescriptionStatusId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Prescriptions", x => x.PrescriptionId);
                    table.ForeignKey(
                        name: "FK_Prescriptions_MedicalRecords_MedicalRecordId",
                        column: x => x.MedicalRecordId,
                        principalTable: "MedicalRecords",
                        principalColumn: "MedicalRecordId");
                    table.ForeignKey(
                        name: "FK_Prescriptions_Patients_PatientId",
                        column: x => x.PatientId,
                        principalTable: "Patients",
                        principalColumn: "PatientId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Prescriptions_PrescriptionStatuses_PrescriptionStatusId",
                        column: x => x.PrescriptionStatusId,
                        principalTable: "PrescriptionStatuses",
                        principalColumn: "PrescriptionStatusId");
                    table.ForeignKey(
                        name: "FK_Prescriptions_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Appointments",
                columns: table => new
                {
                    AppointmentId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AppointmentDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    AppointmentTime = table.Column<TimeSpan>(type: "time", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    StatusMessage = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Note = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsPaid = table.Column<bool>(type: "bit", nullable: false),
                    PaymentDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DoctorId = table.Column<int>(type: "int", nullable: false),
                    PatientId = table.Column<int>(type: "int", nullable: false),
                    AppointmentTypeId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Appointments", x => x.AppointmentId);
                    table.ForeignKey(
                        name: "FK_Appointments_AppointmentTypes_AppointmentTypeId",
                        column: x => x.AppointmentTypeId,
                        principalTable: "AppointmentTypes",
                        principalColumn: "AppointmentTypeId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Appointments_Doctors_DoctorId",
                        column: x => x.DoctorId,
                        principalTable: "Doctors",
                        principalColumn: "DoctorId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Appointments_Patients_PatientId",
                        column: x => x.PatientId,
                        principalTable: "Patients",
                        principalColumn: "PatientId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "DoctorSpecializations",
                columns: table => new
                {
                    DoctorSpecializationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DoctorId = table.Column<int>(type: "int", nullable: false),
                    SpecializationId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DoctorSpecializations", x => x.DoctorSpecializationId);
                    table.ForeignKey(
                        name: "FK_DoctorSpecializations_Doctors_DoctorId",
                        column: x => x.DoctorId,
                        principalTable: "Doctors",
                        principalColumn: "DoctorId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_DoctorSpecializations_Specializations_SpecializationId",
                        column: x => x.SpecializationId,
                        principalTable: "Specializations",
                        principalColumn: "SpecializationId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "PatientDoctorFavorites",
                columns: table => new
                {
                    PatientId = table.Column<int>(type: "int", nullable: false),
                    DoctorId = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PatientDoctorFavorites", x => new { x.PatientId, x.DoctorId });
                    table.ForeignKey(
                        name: "FK_PatientDoctorFavorites_Doctors_DoctorId",
                        column: x => x.DoctorId,
                        principalTable: "Doctors",
                        principalColumn: "DoctorId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_PatientDoctorFavorites_Patients_PatientId",
                        column: x => x.PatientId,
                        principalTable: "Patients",
                        principalColumn: "PatientId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Transactions",
                columns: table => new
                {
                    TransactionId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Amount = table.Column<double>(type: "float", nullable: false),
                    TransactionDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    PaymentMethod = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PaymentId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PayerId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PatientId = table.Column<int>(type: "int", nullable: false),
                    AppointmentId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Transactions", x => x.TransactionId);
                    table.ForeignKey(
                        name: "FK_Transactions_Appointments_AppointmentId",
                        column: x => x.AppointmentId,
                        principalTable: "Appointments",
                        principalColumn: "AppointmentId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Transactions_Patients_PatientId",
                        column: x => x.PatientId,
                        principalTable: "Patients",
                        principalColumn: "PatientId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "AppointmentTypes",
                columns: new[] { "AppointmentTypeId", "DeletionTime", "IsDeleted", "Name", "Price" },
                values: new object[,]
                {
                    { 1, null, false, "General Checkup", 50m },
                    { 2, null, false, "Consultation", 80m },
                    { 3, null, false, "Examination", 100m },
                    { 4, null, false, "Follow-up", 40m }
                });

            migrationBuilder.InsertData(
                table: "Patients",
                columns: new[] { "PatientId", "DeletionTime", "Email", "FirstName", "IsDeleted", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "ProfilePicture", "RegistrationDate", "Username", "isActive" },
                values: new object[,]
                {
                    { 1, null, "mark.b@mail.com", "Mark", false, "Brown", "O44iKOh/G//phQTcSDoD6bvVYJA=", "xJWRSHLNdETt+kIqCoBJFg==", "062123456", null, new DateTime(2025, 4, 14, 22, 13, 13, 0, DateTimeKind.Unspecified), "mobile", true },
                    { 2, null, "lena.b@mail.com", "Lena", false, "Burgess", "Y5PY6ThpfFSmRPQxSSgEEUfSMDc=", "0gXuSZgjHZnAhePy8gl7RQ==", "062111222", null, new DateTime(2025, 4, 14, 22, 13, 13, 0, DateTimeKind.Unspecified), "lenab", true },
                    { 3, null, "donald.f@mail.com", "Donald", false, "Foster", "qIpSzM06en3MCcODqz5q0JhtBJQ=", "+tA31RiJ9vyUd2Lgu5jgNQ==", "062345678", null, new DateTime(2025, 4, 14, 22, 13, 13, 0, DateTimeKind.Unspecified), "donaldf", true }
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "RoleId", "DeletionTime", "Description", "IsDeleted", "RoleName" },
                values: new object[,]
                {
                    { 1, null, "Administrator with full access to settings, user permissions and platform operations.", false, "Admin" },
                    { 2, null, "Medical professional providing consultations and working with patients.", false, "Doctor" },
                    { 3, null, "Supports doctors by managing appointments and assisting with patient coordination.", false, "Assistant" }
                });

            migrationBuilder.InsertData(
                table: "Specializations",
                columns: new[] { "SpecializationId", "DeletionTime", "Description", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, null, "Specializes in diagnosing and treating diseases of the cardiovascular system.", false, "Cardiology" },
                    { 2, null, "Focuses on the treatment of skin, hair, and nail disorders.", false, "Dermatology" },
                    { 3, null, "Provides medical care for infants, children, and adolescents.", false, "Pediatrics" },
                    { 4, null, "Deals with disorders of the nervous system including the brain and spinal cord.", false, "Neurology" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "UserId", "DeletionTime", "Email", "FirstName", "IsDeleted", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "ProfilePicture", "Username" },
                values: new object[,]
                {
                    { 1, null, "1", "1", false, "1", "XVDI7NKoOCtMiSrKR1uSSGWvA7o=", "NHVv+8KhAiQqFlz7k1P53Q==", "1", new byte[] { 0 }, "1" },
                    { 2, null, "admin@mail.com", "Admin", false, "Test", "wSG+yBth9HCj0O1AdRBL+CJjtR4=", "c0MJh5XS8DYQtkJavp5lsA==", "000000000", new byte[] { 0 }, "desktop" },
                    { 3, null, "robert.t@mail.com", "Robert", false, "Trahan", "uAQkJu5IuKT3FArAvq4E5KbBzRI=", "ppASfJlw8D6P+mNsl7bqMA==", "062543234", new byte[] { 0 }, "doctor" },
                    { 4, null, "paul.u@mail.com", "Paul", false, "Ulrey", "uAQkJu5IuKT3FArAvq4E5KbBzRI=", "ppASfJlw8D6P+mNsl7bqMA==", "062222333", new byte[] { 0 }, "doctor1" },
                    { 5, null, "james.l@mail.com", "James", false, "Lozano", "uAQkJu5IuKT3FArAvq4E5KbBzRI=", "ppASfJlw8D6P+mNsl7bqMA==", "062958342", new byte[] { 0 }, "doctor2" },
                    { 6, null, "helen.e@mail.com", "Helen", false, "Evans", "uAQkJu5IuKT3FArAvq4E5KbBzRI=", "ppASfJlw8D6P+mNsl7bqMA==", "062332123", new byte[] { 0 }, "doctor3" },
                    { 7, null, "sabrina.g@mail.com", "Sabrina", false, "Gallagher", "3JVNj98T0GrBkWatJPLYoaIqBEA=", "/gLAN9q37ktD4sUpWLjN1g==", "062532195", new byte[] { 0 }, "assistant" }
                });

            migrationBuilder.InsertData(
                table: "Doctors",
                columns: new[] { "DoctorId", "Biography", "DeletionTime", "IsDeleted", "StateMachine", "Title", "UserId" },
                values: new object[,]
                {
                    { 1, "Dr. Doctor1 is an experienced specialist in internal medicine. He has dedicated over 10 years to diagnosing and treating a wide range of chronic diseases, with a focus on patient-centered care and health education.", null, false, "draft", "Dr. med.", 3 },
                    { 2, "Dr. Doctor2 is a double specialist in cardiology and neurology. With a strong academic background and clinical expertise, she combines knowledge from both fields to provide comprehensive diagnostic and treatment solutions.", null, false, "active", "Dr. sci. med.", 4 },
                    { 3, "Dr. Doctor3 is a pediatrician with more than 7 years of experience in treating children of all ages. Known for a compassionate approach and excellent communication with both kids and parents.", null, false, "active", "Mr. sci. med.", 5 },
                    { 4, "Dr. Doctor4 is a skilled dermatologist who has worked extensively with skin conditions ranging from acne to rare autoimmune diseases. She emphasizes early diagnosis and personalized treatment plans.", null, false, "active", "Dr. med.", 6 }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "UserRoleId", "ChangeDate", "DeletionTime", "IsDeleted", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 1, 1 },
                    { 2, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 1, 2 },
                    { 3, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 2, 3 },
                    { 4, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 2, 4 },
                    { 5, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 2, 5 },
                    { 6, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 2, 6 },
                    { 7, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 3, 7 }
                });

            migrationBuilder.InsertData(
                table: "WorkingHours",
                columns: new[] { "WorkingHoursId", "Day", "DeletionTime", "EndTime", "IsDeleted", "StartTime", "UserId" },
                values: new object[,]
                {
                    { 1, 1, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 3 },
                    { 2, 2, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 3 },
                    { 3, 3, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 3 },
                    { 4, 4, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 3 },
                    { 5, 5, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 3 },
                    { 6, 1, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 4 },
                    { 7, 2, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 4 },
                    { 8, 3, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 4 },
                    { 9, 4, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 4 },
                    { 10, 5, null, new TimeSpan(0, 14, 0, 0, 0), false, new TimeSpan(0, 8, 0, 0, 0), 4 },
                    { 11, 1, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 5 },
                    { 12, 2, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 5 },
                    { 13, 3, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 5 },
                    { 14, 4, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 5 },
                    { 15, 5, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 5 },
                    { 16, 1, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 6 },
                    { 17, 2, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 6 },
                    { 18, 3, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 6 },
                    { 19, 4, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 6 },
                    { 20, 5, null, new TimeSpan(0, 17, 0, 0, 0), false, new TimeSpan(0, 9, 0, 0, 0), 6 }
                });

            migrationBuilder.InsertData(
                table: "Appointments",
                columns: new[] { "AppointmentId", "AppointmentDate", "AppointmentTime", "AppointmentTypeId", "DeletionTime", "DoctorId", "IsDeleted", "IsPaid", "Note", "PatientId", "PaymentDate", "Status", "StatusMessage" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 7, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 9, 0, 0, 0), 1, null, 1, false, false, "Headache and dizziness", 1, null, "Pending", null },
                    { 2, new DateTime(2025, 7, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 11, 0, 0, 0), 2, null, 2, false, false, "Routine check-up", 2, null, "Approved", "See you on time" },
                    { 3, new DateTime(2025, 7, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 13, 0, 0, 0), 4, null, 3, false, true, "Follow-up for lab results", 3, new DateTime(2025, 5, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", "Confirmed and paid" },
                    { 4, new DateTime(2025, 7, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 10, 0, 0, 0), 3, null, 4, false, false, "Skin irritation consultation", 1, null, "Declined", "Doctor unavailable on selected date" },
                    { 5, new DateTime(2025, 7, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new TimeSpan(0, 14, 0, 0, 0), 2, null, 1, false, false, "Consultation about recurring migraines", 2, null, "Pending", null }
                });

            migrationBuilder.InsertData(
                table: "DoctorSpecializations",
                columns: new[] { "DoctorSpecializationId", "DeletionTime", "DoctorId", "IsDeleted", "SpecializationId" },
                values: new object[,]
                {
                    { 1, null, 1, false, 1 },
                    { 2, null, 2, false, 1 },
                    { 3, null, 2, false, 2 },
                    { 4, null, 3, false, 3 },
                    { 5, null, 4, false, 4 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Appointments_AppointmentTypeId",
                table: "Appointments",
                column: "AppointmentTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Appointments_DoctorId",
                table: "Appointments",
                column: "DoctorId");

            migrationBuilder.CreateIndex(
                name: "IX_Appointments_PatientId",
                table: "Appointments",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_Doctors_UserId",
                table: "Doctors",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_DoctorSpecializations_DoctorId",
                table: "DoctorSpecializations",
                column: "DoctorId");

            migrationBuilder.CreateIndex(
                name: "IX_DoctorSpecializations_SpecializationId",
                table: "DoctorSpecializations",
                column: "SpecializationId");

            migrationBuilder.CreateIndex(
                name: "IX_MedicalRecords_PatientId",
                table: "MedicalRecords",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_PatientId",
                table: "Notifications",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_PatientDoctorFavorites_DoctorId",
                table: "PatientDoctorFavorites",
                column: "DoctorId");

            migrationBuilder.CreateIndex(
                name: "IX_Prescriptions_MedicalRecordId",
                table: "Prescriptions",
                column: "MedicalRecordId");

            migrationBuilder.CreateIndex(
                name: "IX_Prescriptions_PatientId",
                table: "Prescriptions",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_Prescriptions_PrescriptionStatusId",
                table: "Prescriptions",
                column: "PrescriptionStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_Prescriptions_UserId",
                table: "Prescriptions",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_PatientId",
                table: "Reviews",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_UserId",
                table: "Reviews",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_AppointmentId",
                table: "Transactions",
                column: "AppointmentId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_PatientId",
                table: "Transactions",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_RoleId",
                table: "UserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_UserId",
                table: "UserRoles",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_WorkingHours_UserId",
                table: "WorkingHours",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "DoctorSpecializations");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "PatientDoctorFavorites");

            migrationBuilder.DropTable(
                name: "Prescriptions");

            migrationBuilder.DropTable(
                name: "Reviews");

            migrationBuilder.DropTable(
                name: "Transactions");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "WorkingHours");

            migrationBuilder.DropTable(
                name: "Specializations");

            migrationBuilder.DropTable(
                name: "MedicalRecords");

            migrationBuilder.DropTable(
                name: "PrescriptionStatuses");

            migrationBuilder.DropTable(
                name: "Appointments");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "AppointmentTypes");

            migrationBuilder.DropTable(
                name: "Doctors");

            migrationBuilder.DropTable(
                name: "Patients");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
