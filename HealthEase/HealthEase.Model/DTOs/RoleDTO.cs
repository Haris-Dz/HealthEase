using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class RoleDTO
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public string? Description { get; set; }
    }
}
