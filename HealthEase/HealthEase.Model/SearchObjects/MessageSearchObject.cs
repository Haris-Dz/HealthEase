using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class MessageSearchObject : BaseSearchObject
    {
        public int? PatientId { get; set; }
        public int? UserId { get; set; }
        public string? TextGTE { get; set; }
    }

}
