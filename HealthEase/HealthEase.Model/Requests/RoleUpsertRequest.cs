using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class RoleUpsertRequest
    {
        public string RoleName { get; set; } = null!;
        public string? Description { get; set; }
    }
}
