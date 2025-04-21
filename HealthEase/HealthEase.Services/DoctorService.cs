using HealthEase.Model.DTOs;
using HealthEase.Model.Exceptions;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using HealthEase.Services.DoctorStateMachine;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;

namespace HealthEase.Services
{
    public class DoctorService : BaseCRUDServiceAsync<DoctorDTO, DoctorSearchObject, Doctor, DoctorInsertRequest, DoctorUpdateRequest>, IDoctorService
    {
        ILogger<DoctorService> _logger;
        private readonly IUserService _userService;
        private readonly IServiceProvider _serviceProvider;

        public DoctorService(HealthEaseContext context, IMapper mapper, IUserService userService, ILogger<DoctorService> logger, IServiceProvider serviceProvider) : base(context, mapper)
        {
            _userService = userService;
            _logger = logger;
            _serviceProvider = serviceProvider;
        }

        public override IQueryable<Doctor> AddFilter(DoctorSearchObject searchObject, IQueryable<Doctor> query)
        {
            query = base.AddFilter(searchObject, query);
            if (!string.IsNullOrWhiteSpace(searchObject?.FirstNameGTE))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(searchObject.FirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.LastNameGTE))
            {
                query = query.Where(x => x.User.LastName.StartsWith(searchObject.LastNameGTE));
            }
            if (!string.IsNullOrEmpty(searchObject?.FirstLastNameGTE) &&
    (string.IsNullOrEmpty(searchObject?.FirstNameGTE) && string.IsNullOrEmpty(searchObject?.LastNameGTE)))
            {
                query = query.Where(x => (x.User.FirstName + " " + x.User.FirstName).ToLower().StartsWith(searchObject.FirstLastNameGTE.ToLower()));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.EmailGTE))
            {
                query = query.Where(x => x.User.Email == searchObject.EmailGTE);
            }
            if (searchObject.SpecializationIds != null && searchObject.SpecializationIds.Any())
            {
                query = query.Where(d =>
                    d.DoctorSpecializations.Any(ds => searchObject.SpecializationIds.Contains(ds.SpecializationId)));
            }

            query = query.Where(x => !x.IsDeleted);
            return query;
        }
        //public override async Task BeforeInsertAsync(DoctorInsertRequest request, Doctor entity, CancellationToken cancellationToken = default)
        //{
        //    if (entity.UserId > 0 && request.User != null)
        //        throw new Exception("Provide either an existing UserId or a new User object, not both.");

        //    if (entity.UserId > 0)
        //    {
        //        entity.UserId = entity.UserId;
        //    }
        //    else if (request.User != null)
        //    {
        //        var createdUser = await _userService.InsertAsync(request.User, cancellationToken);
        //        entity.UserId = createdUser.UserId;
        //    }
        //    else
        //    {
        //        throw new Exception("Doctor must have either a valid UserId or UserInsertRequest.");
        //    }

        //    entity.Biography = request.Biography;
        //    entity.Title = request.Title;
        //    entity.ProfilePicture = request.ProfilePicture;
        //}
        public override async Task<DoctorDTO> InsertAsync(DoctorInsertRequest request, CancellationToken cancellationToken)
        {
            var state = BaseDoctorState.CreateState("initial", _serviceProvider);
            return await state.InsertAsync(request, cancellationToken);
        }


        public override async Task<DoctorDTO> UpdateAsync(int id, DoctorUpdateRequest request, CancellationToken cancellationToken)
        {
            var entity = await GetByIdAsync(id);
            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            return await state.UpdateAsync(id, request,cancellationToken);

        }
        public override async Task DeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await GetByIdAsync(id);
            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            await state.DeleteAsync(id, cancellationToken);
        }
        public async Task<DoctorDTO> ActivateAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await GetByIdAsync(id);
            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            return await state.ActivateAsync(id, cancellationToken);
        }
        public async Task<DoctorDTO> EditAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await GetByIdAsync(id);
            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            return await state.EditAsync(id, cancellationToken);
        }
        public async Task<DoctorDTO> HideAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await GetByIdAsync(id);
            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            return await state.HideAsync(id, cancellationToken);
        }

        //public List<string> AllowedActions(int id)
        //{
        //    _logger.LogInformation($"Allowed actions called for: {id}");

        //    if (id <= 0)
        //    {
        //        var state = BaseProizvodiState.CreateState("initial");
        //        return state.AllowedActions(null);
        //    }
        //    else
        //    {
        //        var entity = Context.Proizvodis.Find(id);
        //        var state = BaseProizvodiState.CreateState(entity.StateMachine);
        //        return state.AllowedActions(entity);
        //    }
        //}


    }
}
