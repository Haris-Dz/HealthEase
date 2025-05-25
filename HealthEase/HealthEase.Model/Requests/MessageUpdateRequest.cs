using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class MessageUpdateRequest
    {
        public bool? IsRead { get; set; }
        public bool? IsDeleted { get; set; }
    }
}
