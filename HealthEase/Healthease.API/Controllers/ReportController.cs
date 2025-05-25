using HealthEase.Model.DTOs.ReportsDTOs;
using HealthEase.Services;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/report")]
public class ReportController : ControllerBase
{
    private readonly IReportService _reportService;

    public ReportController(IReportService reportService)
    {
        _reportService = reportService;
    }

    [HttpGet("summary")]
    public async Task<ActionResult<AdminReportSummaryDTO>> GetSummary([FromQuery] DateTime? startDate, [FromQuery] DateTime? endDate)
    {
        var result = await _reportService.GetSummaryAsync(startDate, endDate);
        return Ok(result);
    }
}
