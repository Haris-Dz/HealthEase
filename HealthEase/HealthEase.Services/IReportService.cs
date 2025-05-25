using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Model.DTOs.ReportsDTOs;

namespace HealthEase.Services
{
    public interface IReportService
    {
        Task<AdminReportSummaryDTO> GetSummaryAsync(DateTime? startDate = null, DateTime? endDate = null);
    }
}
