using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class DoctorUpdateRequest
    {
        public byte[]? ProfilePicture { get; set; }
        public string? Biography { get; set; }
        public string? Title { get; set; }
    }
}
