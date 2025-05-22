using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthEase.Model.DTOs;

namespace HealthEase.Services.Recommender
{
    public interface IRecommenderService
    {
        Task<List<DoctorDTO>> Recommend(int id);
        void TrainModel();
    }
}
