using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class User : BaseEntity
    {
        [Key]
        public int UserId { get; set; }
        [MaxLength(100)]
        public string Username { get; set; } = null!;
        [MaxLength(100)]
        public string FirstName { get; set; } = null!;
        [MaxLength(100)]
        public string LastName { get; set; } = null!;
        [EmailAddress]
        public string Email { get; set; } = null!;
        public string? PhoneNumber { get; set; }
        public string PasswordHash { get; set; } = null!;
        public string PasswordSalt { get; set; } = null!;

        public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();

        public virtual ICollection<WorkingHours> WorkingHours { get; set; } = new List<WorkingHours>();
    }
}
