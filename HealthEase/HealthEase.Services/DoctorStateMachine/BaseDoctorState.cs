using HealthEase.Model.DTOs;
using HealthEase.Model.Exceptions;
using HealthEase.Model.Requests;
using HealthEase.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace HealthEase.Services.DoctorStateMachine
{
    public abstract class BaseDoctorState
    {
        protected readonly HealthEaseContext Context;
        protected readonly IMapper Mapper;
        protected readonly IServiceProvider ServiceProvider;

        public BaseDoctorState(HealthEaseContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }

        public virtual Task<DoctorDTO> InsertAsync(DoctorInsertRequest request, CancellationToken cancellationToken = default)
        {
            throw new UserException("Method not allowed");
        }
        public virtual Task BeforeInsertAsync(DoctorInsertRequest request, Doctor entity, CancellationToken cancellationToken = default)
        {
            throw new UserException("Method not allowed");
        }
        public virtual Task AfterInsertAsync(DoctorInsertRequest request, Doctor entity, CancellationToken cancellationToken = default)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Task<DoctorDTO> UpdateAsync(int id, DoctorUpdateRequest request, CancellationToken cancellation = default)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Task DeleteAsync(int id, CancellationToken cancellationToken = default)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Task<DoctorDTO> ActivateAsync (int id,CancellationToken cancellationToken = default)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Task<DoctorDTO> HideAsync(int id, CancellationToken cancellationToken = default)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Task<DoctorDTO> EditAsync(int id, CancellationToken cancellationToken = default)
        {
            throw new UserException("Method not allowed");
        }

        public virtual List<string> AllowedActions(Doctor entity)
        {
            throw new UserException("Method not allowed");
        }
        public static BaseDoctorState CreateState(string stateName, IServiceProvider serviceProvider)
        {
            return stateName switch
            {
                "initial" => serviceProvider.GetService<InitialDoctorState>(),
                "draft" => serviceProvider.GetService<DraftDoctorState>(),
                "active" => serviceProvider.GetService<ActiveDoctorState>(),
                "hidden" => serviceProvider.GetService<HiddenDoctorState>(),
                _ => throw new Exception("State not recognized")
            };
        }
    }
}
