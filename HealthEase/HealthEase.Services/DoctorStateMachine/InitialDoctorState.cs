﻿using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Services.Database;
using MapsterMapper;

namespace HealthEase.Services.DoctorStateMachine
{
    public class InitialDoctorState : BaseDoctorState
    {
        private readonly IUserService _userService;
        private readonly IDoctorSpecializationService _doctorSpecializationService;

        public InitialDoctorState(
            HealthEaseContext context,
            IMapper mapper,
            IServiceProvider serviceProvider,
            IUserService userService,
            IDoctorSpecializationService doctorSpecializationService
        ) : base(context, mapper, serviceProvider)
        {
            _userService = userService;
            _doctorSpecializationService = doctorSpecializationService;
        }

        public override async Task<DoctorDTO> InsertAsync(DoctorInsertRequest request, CancellationToken cancellationToken)
        {
            var entity = new Doctor();
            await BeforeInsertAsync(request, entity, cancellationToken);
            Context.Doctors.Add(entity);
            await Context.SaveChangesAsync(cancellationToken);
            await AfterInsertAsync(request, entity, cancellationToken);
            return Mapper.Map<DoctorDTO>(entity);
        }
        public override async Task BeforeInsertAsync(DoctorInsertRequest request, Doctor entity, CancellationToken cancellationToken = default)
        {
            if (request.User != null && request.UserId > 0)
                throw new Exception("Provide either an existing UserId or a new User object, not both.");

            if (request.UserId > 0)
            {
                entity.UserId = request.UserId.Value;
            }
            else if (request.User != null)
            {
                if (request.User.RoleId == 0)
                    request.User.RoleId = 2;
                request.User.SkipDoctorCreation = true;
                var createdUser = await _userService.InsertAsync(request.User, cancellationToken);
                entity.UserId = createdUser.UserId;
            }
            else
            {
                throw new Exception("Doctor must have either a valid UserId or UserInsertRequest.");
            }

            entity.Biography = request.Biography;
            entity.Title = request.Title;
            entity.StateMachine = "draft";
            entity.IsDeleted = false;
        }
        public override async Task AfterInsertAsync(DoctorInsertRequest request, Doctor entity, CancellationToken cancellation = default)
        {
            if (request.SpecializationIds != null && request.SpecializationIds.Any())
            {
                await _doctorSpecializationService.SyncDoctorSpecializations(
                    request.SpecializationIds,
                    entity.DoctorId,
                    cancellation
                );
            }
        }
        public override List<string> AllowedActions(Doctor entity)
        {
            return new List<string> { nameof(InsertAsync) };
        }
    }
}
