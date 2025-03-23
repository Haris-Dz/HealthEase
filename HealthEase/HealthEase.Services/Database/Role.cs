using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Role : BaseEntity
    {
        [Key]
        public int RoleId { get; set; }
        [MaxLength(100)]
        public string RoleName { get; set; } = null!;
        public string? Description { get; set; }
        public virtual ICollection<UserRole> UserRole { get; set; } = new List<UserRole>();
    }
}
