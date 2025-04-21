using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.DoctorStateMachine
{
    public class InitialDoctorState: BaseDoctorState
    {
        private readonly IUserService _userService;
        public InitialDoctorState(HealthEaseContext context, IMapper mapper, IServiceProvider serviceProvider, IUserService userService) : base(context, mapper, serviceProvider)
        {
            _userService = userService;
        }
        public override async Task<DoctorDTO> InsertAsync(DoctorInsertRequest request, CancellationToken cancellationToken)
        {
            var set = Context.Set<Doctor>();
            var entity = new Doctor(); // Ručno kreiraj doktora, bez Mapster-a

            if (request.User != null && request.UserId > 0)
                throw new Exception("Provide either an existing UserId or a new User object, not both.");

            if (request.UserId > 0)
            {
                entity.UserId = (int)request.UserId;
            }
            else if (request.User != null)
            {
                var createdUser = await _userService.InsertAsync(request.User, cancellationToken);
                entity.UserId = createdUser.UserId;
            }
            else
            {
                throw new Exception("Doctor must have either a valid UserId or UserInsertRequest.");
            }

            entity.Biography = request.Biography;
            entity.Title = request.Title;
            entity.ProfilePicture = request.ProfilePicture;
            entity.StateMachine = "draft";
            entity.IsDeleted = false;

            set.Add(entity);
            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<DoctorDTO>(entity);
        }


        public override List<string> AllowedActions(Doctor entity)
        {
            return new List<string>() { nameof(InsertAsync) };
        }

    }
}
