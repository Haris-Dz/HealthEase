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

        config.NewConfig<Doctor, DoctorDTO>()
            .Map(dest => dest.DoctorSpecializations, src => src.DoctorSpecializations.Select(ds => ds.Specialization))
            .Map(dest => dest.WorkingHours, src => src.User.WorkingHours)
            .Map(dest => dest.User, src => src.User);

        config.NewConfig<DoctorSpecialization, SpecializationDTO>()
            .Map(dest => dest.SpecializationId, src => src.SpecializationId)
            .Map(dest => dest.Name, src => src.Specialization.Name)
            .Map(dest => dest.Description, src => src.Specialization.Description);

        config.NewConfig<DoctorInsertRequest, Doctor>()
            .Map(dest => dest.Biography, src => src.Biography)
            .Map(dest => dest.Title, src => src.Title)
            .Map(dest => dest.ProfilePicture, src => src.ProfilePicture)
            .Ignore(dest => dest.DoctorId)
            .Ignore(dest => dest.User)
            .Ignore(dest => dest.DoctorSpecializations)
            .Ignore(dest => dest.User.WorkingHours)
            .Ignore(dest => dest.StateMachine);

    }
}
