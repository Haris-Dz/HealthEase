using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class ReviewUpdateRequest
    {
        public int Rating { get; set; }
        public string? Comment { get; set; }
    }
}
