using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Employee : BaseEntity
    {
        [Key]
        public int EmployeeId { get; set; }

        [MaxLength(100)]
        public string FirstName { get; set; } = null!;

        [MaxLength(100)]
        public string LastName { get; set; } = null!;

        [EmailAddress]
        public string Email { get; set; } = null!;

        [MaxLength(100)]
        public string? Position { get; set; }
    }
}
