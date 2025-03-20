using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Notification : BaseEntity
    {
        [Key]
        public int NotificationId { get; set; }

        [Required]
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        [Required]
        public string Message { get; set; } = null!;

        [Required]
        public DateTime CreatedAt { get; set; }
    }
}
