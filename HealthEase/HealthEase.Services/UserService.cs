using System.Linq;
using EasyNetQ;
using HealthEase.Model.DTOs;
using HealthEase.Model.Messages;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace HealthEase.Services
{
    public class UserService : BaseCRUDServiceAsync<UserDTO, UserSearchObject, User, UserInsertRequest, UserUpdateRequest>, IUserService
    {
        ILogger<UserService> _logger;
        public UserService(HealthEaseContext context, IMapper mapper, ILogger<UserService> logger) : base(context, mapper)
        {
            _logger = logger;
        }

        public override IQueryable<User> AddFilter(UserSearchObject searchObject, IQueryable<User> query)
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
            if (searchObject?.IsUserRoleIncluded == true)
            {
                query = query.Include(x => x.UserRoles).ThenInclude(x => x.Role);
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }


        public override async Task BeforeInsertAsync(UserInsertRequest request, User entity, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation($"Adding user: {entity.Username}");
            var user = await Context.Users.FirstOrDefaultAsync(x => x.Username == request.Username);
            if (user != null)
            {
                throw new Exception("Username already exists!");
            }
            var newuser = await Context.Users.FirstOrDefaultAsync(x => x.Email == request.Email);
            if (newuser != null)
            {
                throw new Exception("Email already exists!");
            }
            string newPass = Helpers.Helper.GenerateRandomString(8);
            entity.PasswordSalt = Helpers.Helper.GenerateSalt();
            entity.PasswordHash = Helpers.Helper.GenerateHash(entity.PasswordSalt, newPass);


            string rabbitmq = Environment.GetEnvironmentVariable("RABBIT_MQ") ?? string.Empty;

            var bus = RabbitHutch.CreateBus(rabbitmq);

            Console.WriteLine(bus);
            RegisterMessage registerMessage = new RegisterMessage
            {
                employeeFirstName = request.FirstName,
                employeeLastName = request.LastName,
                email = request.Email,
                username = request.Username,
                password = newPass
            };

            await bus.PubSub.PublishAsync(registerMessage);


        }

        public override async Task AfterInsertAsync(UserInsertRequest request, User entity, CancellationToken cancellationToken = default)
        {
            Context.UserRoles.Add(new UserRole
            {
                UserId = entity.UserId,
                RoleId = request.RoleId,
                ChangeDate = DateTime.Now,
                IsDeleted = false
            });
            var userRole = await Context.Set<Role>()
    .FirstOrDefaultAsync(x => x.RoleName == "Doctor", cancellationToken);
            if (userRole != null && userRole.RoleId == request.RoleId && !request.SkipDoctorCreation)
            {
                Context.Doctors.Add(new Doctor
                {
                    UserId = entity.UserId,
                    IsDeleted = false,
                    StateMachine = "draft"
                });
            }
            await Context.SaveChangesAsync(cancellationToken);

        }

        public override async Task BeforeUpdateAsync(UserUpdateRequest request, User entity, CancellationToken cancellationToken = default)
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

        public override async Task<UserDTO> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await base.GetByIdAsync(id, cancellationToken);
        }
        public override async Task AfterDeleteAsync(User entity, CancellationToken cancellationToken) 
        {
            var doctorEntity = await Context.Set<Doctor>()
    .FirstOrDefaultAsync(x => x.UserId == entity.UserId, cancellationToken);
            if (doctorEntity != null)
            {
                doctorEntity.IsDeleted = true;

                await Context.SaveChangesAsync(cancellationToken);
            }
        }
        public UserDTO Login(string username, string password)
        {
            var entity = Context.Users.Where(u => u.Username == username).Include(ur => ur.UserRoles).ThenInclude(r => r.Role).FirstOrDefault();


            if (entity == null)
            {
                return null;
            }

            var hash = Helpers.Helper.GenerateHash(entity.PasswordSalt, password);

            if (hash != entity.PasswordHash)
            {
                return null;
            }

            return this.Mapper.Map<UserDTO>(entity);
        }
    }
}
