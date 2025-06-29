using HealthEase.Services.Database;
using Microsoft.OpenApi.Models;
using Microsoft.EntityFrameworkCore;
using DotNetEnv;
using HealthEase.Services;
using Healthease.API.Filters;
using Mapster;
using Healthease.API.Auth;
using Microsoft.AspNetCore.Authentication;
using HealthEase.Services.DoctorStateMachine;
using HealthEase.Services.Recommender;
var builder = WebApplication.CreateBuilder(args);
// Add services to the container.

builder.Services.AddTransient<ISpecializationService, SpecializationService>();
builder.Services.AddTransient<IroleService, RoleService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IPatientService, PatientService>();
builder.Services.AddTransient<IDoctorService, DoctorService>();
builder.Services.AddTransient<IWorkingHoursService, WorkingHoursService>();
builder.Services.AddTransient<IAppointmentService, AppointmentService>();
builder.Services.AddTransient<IAppointmentTypeService, AppointmentTypeService>();
builder.Services.AddTransient<IPatientDoctorFavoriteService, PatientDoctorFavoriteService>();
builder.Services.AddTransient<ITransactionService, TransactionService>();
builder.Services.AddTransient<IDoctorSpecializationService, DoctorSpecializationService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<IReviewService, ReviewService>();
builder.Services.AddTransient<IMessageService, MessageService>();
builder.Services.AddTransient<IMedicalRecordService, MedicalRecordService>();
builder.Services.AddTransient<IMedicalRecordEntryService, MedicalRecordEntryService>();

builder.Services.AddTransient<InitialDoctorState>();
builder.Services.AddTransient<DraftDoctorState>();
builder.Services.AddTransient<ActiveDoctorState>();
builder.Services.AddTransient<HiddenDoctorState>();

builder.Services.AddScoped<IRecommenderService, RecommenderService>();
builder.Services.AddScoped<IReportService, ReportService>();

MappingConfig.RegisterMappings();

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ExceptionFilter>();
}
    );
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});
Env.Load("../.env");
var connectionString = Environment.GetEnvironmentVariable("DATABASE_CONNECTION_STRING");
builder.Services.AddDbContext<HealthEaseContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddMapster();

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
builder.Services.AddHttpContextAccessor();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<HealthEaseContext>();
    dataContext.Database.Migrate();
}
app.Run();
