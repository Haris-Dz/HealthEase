using HealthEase.Services.BaseServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Model.DTOs;
using HealthEase.Model.SearchObjects;
using HealthEase.Model.Requests;


namespace HealthEase.Services
{
    public interface ISpecializationService:ICRUDServiceAsync<SpecializationDTO,SpecializationSearchObject,SpecializationUpsertRequest, SpecializationUpsertRequest>
    {
    }
}
