using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace HealthEase.Services.DoctorStateMachine
{
    public class DraftDoctorState : BaseDoctorState
    {
        public DraftDoctorState(HealthEaseContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override async Task<DoctorDTO> UpdateAsync(int id, DoctorUpdateRequest request, CancellationToken cancellationToken)
        {
            var set = Context.Set<Doctor>();
            var entity = set.Find(id);
            Mapper.Map(request, entity);
            await Context.SaveChangesAsync(cancellationToken);
            return Mapper.Map<DoctorDTO>(entity);
        }
        public override async Task DeleteAsync(int id, CancellationToken cancellationToken)
        {
            var set = Context.Set<Doctor>();

            var entity = set.Find(id);

            entity.IsDeleted = true;
            entity.DeletionTime = DateTime.Now;

            await Context.SaveChangesAsync(cancellationToken);
        }
        public override async Task<DoctorDTO> ActivateAsync(int id, CancellationToken cancellationToken)
        {
            var set = Context.Set<Doctor>();

            var entity = await set.FindAsync(new object[] { id }, cancellationToken);

            if (entity == null)
                throw new Exception("Doctor not found");

            entity.StateMachine = "active";

            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<DoctorDTO>(entity);
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
            return new List<string>() { nameof(ActivateAsync), nameof(UpdateAsync), nameof(HideAsync), nameof(DeleteAsync) };
        }
    }
}
