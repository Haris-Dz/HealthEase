using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class User : BaseEntity
    {
        [Key]
        public int UserId { get; set; }
        [Required, MaxLength(100)]
        public string FirstName { get; set; } = null!;
        [Required, MaxLength(100)]
        public string LastName { get; set; } = null!;
        [Required, EmailAddress]
        public string Email { get; set; } = null!;
        [Required]
        public string PasswordHash { get; set; } = null!;
        [Required]
        public string PasswordSalt { get; set; } = null!;
        [Required]
        public UserRole Role { get; set; } = null!;

        public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
        public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
    }
}
