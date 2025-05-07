using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using HealthEase.Model.DTOs;
using HealthEase.Model.Exceptions;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace HealthEase.Services
{
    public class PatientDoctorFavoriteService : IPatientDoctorFavoriteService
    {
        private readonly HealthEaseContext _context;
        private readonly IMapper _mapper;

        public PatientDoctorFavoriteService(HealthEaseContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<PatientDoctorFavoriteDTO?> ToggleFavoriteAsync(PatientDoctorFavoriteInsertRequest request, CancellationToken cancellationToken = default)
        {
            var existing = await _context.PatientDoctorFavorites
                .FirstOrDefaultAsync(x => x.PatientId == request.PatientId && x.DoctorId == request.DoctorId, cancellationToken);

            if (existing != null)
            {
                _context.PatientDoctorFavorites.Remove(existing);
                await _context.SaveChangesAsync(cancellationToken);
                return null;
            }

            var entity = new PatientDoctorFavorite
            {
                PatientId = request.PatientId,
                DoctorId = request.DoctorId,
                CreatedAt = DateTime.UtcNow
            };

            _context.PatientDoctorFavorites.Add(entity);
            await _context.SaveChangesAsync(cancellationToken);

            var fullEntity = await _context.PatientDoctorFavorites
                .Include(x => x.Doctor).ThenInclude(d => d.User)
                .FirstAsync(x => x.PatientId == entity.PatientId && x.DoctorId == entity.DoctorId, cancellationToken);

            return _mapper.Map<PatientDoctorFavoriteDTO>(fullEntity);
        }

        public async Task<IEnumerable<PatientDoctorFavoriteDTO>> GetAllFavoritesByPatientIdAsync(int patientId, CancellationToken cancellationToken = default)
        {
            var query = await _context.PatientDoctorFavorites
                .Where(x => x.PatientId == patientId)
                .Include(x => x.Doctor).ThenInclude(d => d.User)
                .ToListAsync(cancellationToken);

            return query.Adapt<List<PatientDoctorFavoriteDTO>>();
        }

        public async Task DeleteAsync(int patientId, int doctorId, CancellationToken cancellationToken = default)
        {
            var entity = await _context.PatientDoctorFavorites
                .FirstOrDefaultAsync(x => x.PatientId == patientId && x.DoctorId == doctorId, cancellationToken);

            if (entity == null)
                throw new UserException("Favorite not found");

            _context.PatientDoctorFavorites.Remove(entity);
            await _context.SaveChangesAsync(cancellationToken);
        }
    }
}
