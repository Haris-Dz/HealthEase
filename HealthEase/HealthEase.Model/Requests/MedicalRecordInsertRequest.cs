using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class MedicalRecordInsertRequest
    {
        public int PatientId { get; set; }
        public string? Notes { get; set; }
    }
}
