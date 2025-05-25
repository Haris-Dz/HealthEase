using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class MessageInsertRequest
    {
        public int PatientId { get; set; }
        public int UserId { get; set; }
        public int SenderId { get; set; }
        public string SenderType { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
    }
}
