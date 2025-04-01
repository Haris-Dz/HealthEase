using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class PatientInsertRequest
    {
        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string? PhoneNumber { get; set; }

        public string Username { get; set; } = null!;

        public byte[]? ProfilePicture { get; set; }

        public string Password { get; set; } = null!;

        public string PasswordConfirmation { get; set; } = null!;
    }
}
