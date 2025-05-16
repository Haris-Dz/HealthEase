using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class DoctorUpdateRequest
    {
        public string? Biography { get; set; }
        public string? Title { get; set; }
        public List<int> SpecializationIds { get; set; } = new List<int>();
    }
}
