using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class UserInsertRequest
    {
        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string? PhoneNumber { get; set; }

        public byte[]? ProfilePicture { get; set; }
        public string Username { get; set; } = null!;

        [Required]
        public int RoleId { get; set; }
        public bool SkipDoctorCreation { get; set; } = false;

        // public string Password { get; set; } = null!;
        // public string PasswordConfirmation { get; set; } = null!;
    }
}
