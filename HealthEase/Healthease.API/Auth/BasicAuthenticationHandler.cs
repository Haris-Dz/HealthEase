using Azure.Core;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Encodings.Web;
using System.Text;
using HealthEase.Services;

namespace Healthease.API.Auth
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IUserService _userService;
        //private readonly IPatientService _patientService;

        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            ISystemClock clock,
            IUserService userService
            /*,IPatientService PatientService*/) : base(options, logger, encoder, clock)
        {
            _userService = userService;
            //this._patientService = patientService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header");
            }

            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialBytes = Convert.FromBase64String(authHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialBytes).Split(':');

            var username = credentials[0];
            var password = credentials[1];

            var user = _userService.Login(username, password);

            if (user == null)
            {
                return AuthenticateResult.Fail("Auth failed");
                //potrebna provjera da li je pacijent, te ako nije vracamo fail
                //var patient = _patientService.Login(username, password);

                //if (patient == null)
                //{
                //    return AuthenticateResult.Fail("Auth failed");
                //}
                //else
                //{
                //    var claims = new List<Claim>()
                //    {
                //    new Claim(ClaimTypes.Name, patient.FirstName),
                //    new Claim(ClaimTypes.NameIdentifier, citalac.Username)
                //    };

                //    claims.Add(new Claim(ClaimTypes.Role, "Patient"));

                //    var identity = new ClaimsIdentity(claims, Scheme.Name);

                //    var principal = new ClaimsPrincipal(identity);

                //    var ticket = new AuthenticationTicket(principal, Scheme.Name);
                //    return AuthenticateResult.Success(ticket);
                //}
            }
            else
            {
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Role, user.FirstName),
                    new Claim(ClaimTypes.NameIdentifier, user.Username)
                };

                foreach (var role in user.UserRoles)
                {
                    claims.Add(new Claim(ClaimTypes.Role, role.Role.RoleName));
                }

                var identity = new ClaimsIdentity(claims, Scheme.Name);

                var principal = new ClaimsPrincipal(identity);

                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
        }
    }
}
