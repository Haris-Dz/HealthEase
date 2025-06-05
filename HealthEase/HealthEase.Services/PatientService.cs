
using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services
{
    public class PatientService : BaseCRUDServiceAsync<PatientDTO, PatientSearchObject, Patient, PatientInsertRequest, PatientUpdateRequest>, IPatientService
    {
        ILogger<PatientService> _logger;
        IMedicalRecordService _medicalRecordService;
        public PatientService(HealthEaseContext context, IMapper mapper, ILogger<PatientService> logger, IMedicalRecordService medicalRecordService) : base(context, mapper)
        {
            _logger = logger;
            _medicalRecordService = medicalRecordService;
        }
        public override IQueryable<Patient> AddFilter(PatientSearchObject searchObject, IQueryable<Patient> query)
        {
            query = base.AddFilter(searchObject, query);
            if (!string.IsNullOrWhiteSpace(searchObject?.FirstNameGTE))
            {
                query = query.Where(x => x.FirstName.StartsWith(searchObject.FirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.LastNameGTE))
            {
                query = query.Where(x => x.LastName.StartsWith(searchObject.LastNameGTE));
            }
            if (!string.IsNullOrEmpty(searchObject?.FirstLastNameGTE) &&
    (string.IsNullOrEmpty(searchObject?.FirstNameGTE) && string.IsNullOrEmpty(searchObject?.LastNameGTE)))
            {
                query = query.Where(x => (x.FirstName + " " + x.LastName).ToLower().StartsWith(searchObject.FirstLastNameGTE.ToLower()));
            }
            if (!string.IsNullOrEmpty(searchObject?.PhoneNumber))
            {
                query = query.Where(x => x.PhoneNumber == searchObject.PhoneNumber);
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.EmailGTE))
            {
                query = query.Where(x => x.Email == searchObject.EmailGTE);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Username))
            {
                query = query.Where(x => x.Username == searchObject.Username);
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.UsernameGTE))
            {
                query = query.Where(p => p.Username.ToLower().StartsWith(searchObject.UsernameGTE.ToLower()));
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
        public override async Task BeforeInsertAsync(PatientInsertRequest request, Patient entity, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation($"Adding patient: {entity.Username}");
            var patient = await Context.Patients.FirstOrDefaultAsync(x => x.Username == request.Username);
            if (patient != null)
            {
                throw new Exception("Username already exists!");
            }
            var newuser = await Context.Patients.FirstOrDefaultAsync(x => x.Email == request.Email);
            if (newuser != null)
            {
                throw new Exception("Email already exists!");
            }
            if (string.IsNullOrEmpty(request.Password) || string.IsNullOrEmpty(request.PasswordConfirmation))
            {
                throw new Exception("Password and password confirmation required!");
            }
            if(request.Password != request.PasswordConfirmation)
            {
                throw new Exception("Password and password confirmation must match!");
            }
            if(request.ProfilePicture == null)
            {
                entity.ProfilePicture = null;
            }
            entity.isActive = true;
            entity.RegistrationDate = DateTime.Now;
            entity.PasswordSalt = Helpers.Helper.GenerateSalt();
            entity.PasswordHash = Helpers.Helper.GenerateHash(entity.PasswordSalt, request.Password);

            //await rabbitMqService.SendAnEmail(new EmailDTO
            //{
            //    EmailTo = entity.Email,
            //    Message = $"Poštovani<br>" +
            //  $"Korisnicko ime: {entity.KorisnickoIme}<br>" +
            //  $"Lozinka: {lozinka}<br><br>" +
            //  $"Srdačan pozdrav",
            //    ReceiverName = entity.Ime + " " + entity.Prezime,
            //    Subject = "Registracija"
            //});
        }
        public override async Task AfterInsertAsync(PatientInsertRequest request, Patient entity, CancellationToken cancellationToken = default) 
        {
            await _medicalRecordService.InsertAsync(new MedicalRecordInsertRequest
            {
                PatientId = entity.PatientId,
                Notes = ""
            }, cancellationToken);
        }
        public override async Task BeforeUpdateAsync(PatientUpdateRequest request, Patient entity, CancellationToken cancellationToken = default)
        {
            if (request.Password != null && request.PasswordConfirmation != null && request.CurrentPassword != null)
            {
                var currentPw = Helpers.Helper.GenerateHash(entity.PasswordSalt, request.CurrentPassword);

                if (currentPw != entity.PasswordHash)
                {
                    throw new Exception("Invalid current password");
                }
                if (request.Password != request.PasswordConfirmation)
                {
                    throw new Exception("Password and password confirmation must match!");
                }
                entity.PasswordSalt = Helpers.Helper.GenerateSalt();
                entity.PasswordHash = Helpers.Helper.GenerateHash(entity.PasswordSalt, request.Password);
            }
        }
        public override async Task<PatientDTO> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await base.GetByIdAsync(id, cancellationToken);
        }
        public PatientDTO Login(string username, string password)
        {
            var entity = Context.Patients.Where(u => u.Username == username).FirstOrDefault();


            if (entity == null || entity.IsDeleted || !entity.isActive)
            {
                return null;
            }
            var hash = Helpers.Helper.GenerateHash(entity.PasswordSalt, password);

            if (hash != entity.PasswordHash)
            {
                return null;
            }

            return this.Mapper.Map<PatientDTO>(entity);
        }
    }
}
