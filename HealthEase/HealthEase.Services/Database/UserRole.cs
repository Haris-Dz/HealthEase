using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class UserRole:BaseEntity
    {
        public int UserRoleId{ get; set; }

        public int UserId { get; set; }

        public int RoleId { get; set; }

        public DateTime ChangeDate { get; set; }

        public virtual User User { get; set; } = null!;

        public virtual Role Role { get; set; } = null!;
    }
}
