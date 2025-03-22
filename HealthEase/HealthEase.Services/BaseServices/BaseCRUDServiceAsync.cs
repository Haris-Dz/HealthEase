using AutoMapper;
using HealthEase.Model.Exceptions;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services.BaseServices
{
    public class BaseCRUDServiceAsync<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseServiceAsync<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BaseCRUDServiceAsync(HealthEaseContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task<TModel> InsertAsync(TInsert request, CancellationToken cancellationToken = default)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request);

            await BeforeInsertAsync(request, entity);

            Context.Add(entity);
            await Context.SaveChangesAsync(cancellationToken);

            await AfterInsertAsync(request, entity);

            return Mapper.Map<TModel>(entity);
        }
        public virtual async Task BeforeInsertAsync(TInsert request, TDbEntity entity, CancellationToken cancellationToken = default) { }
        public virtual async Task AfterInsertAsync(TInsert request, TDbEntity entity, CancellationToken cancellationToken = default) { }

        public virtual async Task<TModel> UpdateAsync(int id, TUpdate request, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<TDbEntity>();

            var entity = await set.FindAsync(id, cancellationToken);
            if (entity == null)
            {
                throw new UserException("Unable to find an object with the provided ID!");
            }
            Mapper.Map(request, entity);

            await BeforeUpdateAsync(request, entity);

            await Context.SaveChangesAsync(cancellationToken);

            await AfterUpdateAsync(request, entity);

            return Mapper.Map<TModel>(entity);
        }

        public virtual async Task BeforeUpdateAsync(TUpdate request, TDbEntity entity, CancellationToken cancellationToken = default) { }
        public virtual async Task AfterUpdateAsync(TUpdate request, TDbEntity entity, CancellationToken cancellationToken = default) { }

        public virtual async Task DeleteAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await Context.Set<TDbEntity>().FindAsync(id, cancellationToken);
            if (entity == null)
            {
                throw new UserException("Unable to find an object with the provided ID!");
            }

            if (entity is ISoftDeletable softDeleteEntity)
            {
                softDeleteEntity.IsDeleted = true;
                softDeleteEntity.DeletionTime = DateTime.Now;
                Context.Update(entity);
            }
            else
            {
                Context.Remove(entity);
            }

            await Context.SaveChangesAsync(cancellationToken);

            await AfterDeleteAsync(entity, cancellationToken);
        }

        public virtual async Task AfterDeleteAsync(TDbEntity entity, CancellationToken cancellationToken) { }
    }
}
