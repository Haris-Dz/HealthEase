using HealthEase.Model.DTOs;
using HealthEase.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.DoctorStateMachine
{
    public class ActiveDoctorState : BaseDoctorState
    {
        public ActiveDoctorState(HealthEaseContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override async Task<DoctorDTO> HideAsync(int id, CancellationToken cancellationToken)
        {
            var set = Context.Set<Doctor>();

            var entity = await set.FindAsync(new object[] { id }, cancellationToken);

            if (entity == null)
                throw new Exception("Doctor not found");

            entity.StateMachine = "hidden";

            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<DoctorDTO>(entity);
        }

        public override List<string> AllowedActions(Doctor entity)
        {
            return new List<string>() { nameof(HideAsync) };
        }
    }
}
