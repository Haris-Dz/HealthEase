using HealthEase.Model.DTOs;
using HealthEase.Model.Exceptions;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using HealthEase.Services.DoctorStateMachine;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace HealthEase.Services
{
    public class DoctorService : BaseCRUDServiceAsync<DoctorDTO, DoctorSearchObject, Doctor, DoctorInsertRequest, DoctorUpdateRequest>, IDoctorService
    {
        private readonly ILogger<DoctorService> _logger;
        private readonly IServiceProvider _serviceProvider;

        public DoctorService(
            HealthEaseContext context,
            IMapper mapper,
            ILogger<DoctorService> logger,
            IServiceProvider serviceProvider
        ) : base(context, mapper)
        {
            _logger = logger;
            _serviceProvider = serviceProvider;
        }

        public override IQueryable<Doctor> AddFilter(DoctorSearchObject searchObject, IQueryable<Doctor> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.FirstNameGTE))
                query = query.Where(x => x.User.FirstName.StartsWith(searchObject.FirstNameGTE));

            if (!string.IsNullOrWhiteSpace(searchObject?.LastNameGTE))
                query = query.Where(x => x.User.LastName.StartsWith(searchObject.LastNameGTE));

            if (!string.IsNullOrEmpty(searchObject?.FirstLastNameGTE) &&
                string.IsNullOrEmpty(searchObject.FirstNameGTE) &&
                string.IsNullOrEmpty(searchObject.LastNameGTE))
            {
                query = query.Where(x =>
                    (x.User.FirstName + " " + x.User.LastName).ToLower().StartsWith(searchObject.FirstLastNameGTE.ToLower()));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.EmailGTE))
                query = query.Where(x => x.User.Email == searchObject.EmailGTE);

            if (searchObject.SpecializationIds != null && searchObject.SpecializationIds.Any())
            {
                query = query.Where(d =>
                    d.DoctorSpecializations.Any(ds => searchObject.SpecializationIds.Contains(ds.SpecializationId)));
            }

            return query
                .Where(x => !x.IsDeleted)
                .Include(x => x.User)
                .Include(x => x.DoctorSpecializations)
                    .ThenInclude(ds => ds.Specialization)
                .Include(x => x.User.WorkingHours);
        }
        private async Task<Doctor> LoadDoctorWithIncludesAsync(int id, CancellationToken cancellationToken)
        {
            var doctor = await Context.Doctors
                .Include(d => d.User)
                .Include(d => d.User.WorkingHours)
                .Include(d => d.DoctorSpecializations)
                    .ThenInclude(ds => ds.Specialization)
                .FirstOrDefaultAsync(d => d.DoctorId == id, cancellationToken);

            if (doctor == null)
            {
                throw new UserException("Doctor not found!");
            }

            return doctor;
        }


        public override async Task<DoctorDTO> InsertAsync(DoctorInsertRequest request, CancellationToken cancellationToken)
        {
            var state = BaseDoctorState.CreateState("initial", _serviceProvider);
            return await state.InsertAsync(request, cancellationToken);
        }
        public override async Task<DoctorDTO> UpdateAsync(int id, DoctorUpdateRequest request, CancellationToken cancellationToken)
        {
            var entity = await LoadDoctorWithIncludesAsync(id, cancellationToken);

            if (entity == null)
                throw new UserException("Doctor not found!");

            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            return await state.UpdateAsync(id, request, cancellationToken);
        }


        public override async Task DeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await LoadDoctorWithIncludesAsync(id, cancellationToken);

            if (entity == null)
                throw new UserException("Doctor not found!");

            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            await state.DeleteAsync(id, cancellationToken);
        }


        public async Task<DoctorDTO> ActivateAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await LoadDoctorWithIncludesAsync(id, cancellationToken);

            if (entity == null)
                throw new UserException("Doctor not found!");

            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            return await state.ActivateAsync(id, cancellationToken);
        }


        public async Task<DoctorDTO> EditAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await LoadDoctorWithIncludesAsync(id, cancellationToken);

            if (entity == null)
                throw new UserException("Doctor not found!");

            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            return await state.EditAsync(id, cancellationToken);
        }


        public async Task<DoctorDTO> HideAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await LoadDoctorWithIncludesAsync(id, cancellationToken);

            if (entity == null)
                throw new UserException("Doctor not found!");

            var state = BaseDoctorState.CreateState(entity.StateMachine, _serviceProvider);
            return await state.HideAsync(id, cancellationToken);
        }
    }
}
