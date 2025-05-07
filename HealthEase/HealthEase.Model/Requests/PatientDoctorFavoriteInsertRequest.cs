using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace HealthEase.Model.Requests
{
    public class PatientDoctorFavoriteInsertRequest
    {
        [Required] 
        public int PatientId { get; set; }
        [Required]
        public int DoctorId { get; set; }
    }
}
