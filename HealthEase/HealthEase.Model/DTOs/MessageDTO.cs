using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.DTOs
{
    public class MessageDTO
    {
        public int MessageId { get; set; }
        public int PatientId { get; set; }
        public int UserId { get; set; }
        public int SenderId { get; set; }
        public string SenderType { get; set; }
        public string Content { get; set; } = string.Empty;
        public DateTime SentAt { get; set; }
        public bool IsRead { get; set; }
        public bool IsDeleted { get; set; }
        public PatientDTO? Patient { get; set; }
        public UserDTO? User { get; set; }
    }
}