using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public partial class Payment : BaseEntity
    {
        [Key]
        public int PaymentId { get; set; }
        public double? Amount { get; set; }
        public int PatientId { get; set; }
        [ForeignKey("PatientId")]
        public virtual Patient Patient { get; set; } = null!;
        public DateTime? PaymentDate { get; set; }
    }
}
