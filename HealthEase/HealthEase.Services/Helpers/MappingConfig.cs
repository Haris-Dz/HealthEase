using HealthEase.Model.DTOs;
using HealthEase.Model.Requests;
using HealthEase.Services.Database;
using Mapster;
using System.Linq;

public static class MappingConfig
{
    public static void RegisterMappings()
    {
        var config = TypeAdapterConfig.GlobalSettings;

        config.Default.IgnoreNullValues(true);


        config.NewConfig<Doctor, DoctorDTO>()
            .Map(dest => dest.DoctorSpecializations,
                 src => src.DoctorSpecializations != null
                     ? src.DoctorSpecializations
                           .Where(ds => ds.Specialization != null && !ds.Specialization.IsDeleted && !ds.IsDeleted)
                           .Select(ds => new SpecializationDTO
                           {
                               SpecializationId = ds.Specialization.SpecializationId,
                               Name = ds.Specialization.Name,
                               Description = ds.Specialization.Description
                           })
                            : new List<SpecializationDTO>())

            .Map(dest => dest.WorkingHours,
                 src => src.User != null && src.User.WorkingHours != null
                     ? src.User.WorkingHours.Where(wh => !wh.IsDeleted)
                     : new List<WorkingHours>())
            .Map(dest => dest.User,
                 src => src.User != null ? src.User : new User());



        config.NewConfig<DoctorSpecialization, SpecializationDTO>()
            .Map(dest => dest.SpecializationId, src => src.SpecializationId)
            .Map(dest => dest.Name, src => src.Specialization.Name)
            .Map(dest => dest.Description, src => src.Specialization.Description);

        config.NewConfig<Appointment, AppointmentDTO>()
            .Map(dest => dest.Doctor, src => src.Doctor)
            .Map(dest => dest.Patient, src => src.Patient)
            .Map(dest => dest.AppointmentType, src => src.AppointmentType);

        config.NewConfig<Transaction, TransactionDTO>()
            .Map(dest => dest.Patient, src => src.Patient)
            .Map(dest => dest.Appointment, src => src.Appointment);

        config.NewConfig<DoctorInsertRequest, Doctor>()
            .Map(dest => dest.Biography, src => src.Biography)
            .Map(dest => dest.Title, src => src.Title)
            .Ignore(dest => dest.DoctorId)
            .Ignore(dest => dest.User)
            .Ignore(dest => dest.DoctorSpecializations)
            .Ignore(dest => dest.User.WorkingHours)
            .Ignore(dest => dest.StateMachine);

        config.NewConfig<PatientDoctorFavorite, PatientDoctorFavoriteDTO>()
            .Map(dest => dest.Doctor, src => src.Doctor);

        config.NewConfig<TransactionInsertRequest, Transaction>()
            .Map(dest => dest.AppointmentId, src => src.AppointmentId)
            .Map(dest => dest.PatientId, src => src.PatientId)
            .Map(dest => dest.Amount, src => src.Amount)
            .Map(dest => dest.PaymentMethod, src => src.PaymentMethod)
            .Map(dest => dest.PaymentId, src => src.PaymentId)
            .Map(dest => dest.PayerId, src => src.PayerId)
            .Ignore(dest => dest.Appointment)
            .Ignore(dest => dest.Patient);

        config.NewConfig<Notification, NotificationDTO>()
            .Map(dest => dest.Patient, src => src.Patient);




    }
}
