using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.Database
{
    public abstract class BaseEntity : ISoftDeletable
    {
        public bool IsDeleted { get; set; } = false;
        public DateTime? DeletionTime { get; set; } = null;

        public void Undo()
        {
            IsDeleted = false;
            DeletionTime = null;
        }
    }
}
