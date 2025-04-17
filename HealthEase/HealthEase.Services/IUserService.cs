using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Model.SearchObjects;
using HealthEase.Services.BaseServices;
using HealthEase.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthEase.Services
{
    public interface IUserService : ICRUDServiceAsync<UserDTO, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        UserDTO Login(string username, string password);
    }
}
