using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Message : BaseEntity
    {
        public int MessageId { get; set; }
        public int PatientId { get; set; }
        public int UserId { get; set; }

        public int SenderId { get; set; } 
        public string SenderType { get; set; } 
        public string Content { get; set; } = "";
        public DateTime SentAt { get; set; } = DateTime.Now;
        public bool IsRead { get; set; } = false;

        public virtual Patient? Patient { get; set; }
        public virtual User? User { get; set; }
    }
}
