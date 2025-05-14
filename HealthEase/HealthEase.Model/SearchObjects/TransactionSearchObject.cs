using System;
using System.Collections.Generic;
using System.Text;

namespace HealthEase.Model.SearchObjects
{
    public class TransactionSearchObject: BaseSearchObject
    {
        public int? PatientId { get; set; }
        public string? PatientName { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}
