﻿using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services
{
    public interface IWorkingHoursService : ICRUDServiceAsync<WorkingHoursDTO, WorkingHoursSearchObject, WorkingHoursUpsertRequest, WorkingHoursUpsertRequest>
    {
        Task<List<WorkingHoursDTO>> BulkUpsertAsync(List<WorkingHoursUpsertRequest> requestList);
    }
}
