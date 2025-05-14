using System;
using System.Collections.Generic;
using System.Text;
using HealthEase.Model.DTOs;

namespace HealthEase.Model.Requests
{
    public class TransactionInsertRequest
    {
        public double Amount { get; set; }
        public string? PaymentMethod { get; set; }
        public string? PaymentId { get; set; }
        public string? PayerId { get; set; }
        public int PatientId { get; set; }
        public int AppointmentId { get; set; }
    }
}
