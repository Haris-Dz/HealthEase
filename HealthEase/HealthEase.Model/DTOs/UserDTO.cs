using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class UserDTO
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; } 
        public string LastName { get; set; } 
        public string Email { get; set; }
        public string? PhoneNumber { get; set; }
        public bool IsDeleted { get; set; }
        public int UserRoleId { get; set; }
        public virtual ICollection<UserRoleDTO> UserRole { get; set; } = new List<UserRoleDTO>();
    }
}
