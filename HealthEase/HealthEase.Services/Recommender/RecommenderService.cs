using HealthEase.Model.DTOs;
using HealthEase.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using System.Text;

namespace HealthEase.Services.Recommender
{
    public class RecommenderService : IRecommenderService
    {
        private readonly HealthEaseContext _context;
        private readonly IMapper _mapper;
        private static MLContext mlContext = new MLContext();
        private static object _lock = new object();
        private const string ModelPath = "doctor-content-model.zip";
        private static ITransformer model = null;

        public RecommenderService(HealthEaseContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            if (model == null)
                LoadOrTrainModel();
        }

        // Data Classes
        public class DoctorData
        {
            public int DoctorId { get; set; }
            public string Specializations { get; set; }
            public string AppointmentTypes { get; set; }
        }

        public class DoctorPrediction
        {
            [VectorType]
            public float[] Features { get; set; }
        }

        // Train Model (Featurizer pipeline)
        public void TrainModel()
        {
            lock (_lock)
            {
                var allDoctors = _context.Doctors
                    .Include(d => d.DoctorSpecializations)
                        .ThenInclude(ds => ds.Specialization)
                    .Include(d => d.Appointments)
                        .ThenInclude(a => a.AppointmentType)
                    .Where(d => !d.IsDeleted && d.StateMachine == "active")
                    .ToList();

                var allDoctorData = allDoctors.Select(d => new DoctorData
                {
                    DoctorId = d.DoctorId,
                    Specializations = string.Join(", ", d.DoctorSpecializations.Where(ds => ds.Specialization != null && !ds.Specialization.IsDeleted).Select(ds => ds.Specialization.Name)),
                    AppointmentTypes = string.Join(", ", d.Appointments.Where(a => a.AppointmentType != null && !a.AppointmentType.IsDeleted).Select(a => a.AppointmentType.Name).Distinct())
                }).ToList();

                var data = mlContext.Data.LoadFromEnumerable(allDoctorData);

                var pipeline = mlContext.Transforms.Text.FeaturizeText("SpecFeatures", nameof(DoctorData.Specializations))
                    .Append(mlContext.Transforms.Text.FeaturizeText("AppTypeFeatures", nameof(DoctorData.AppointmentTypes)))
                    .Append(mlContext.Transforms.Concatenate("Features", "SpecFeatures", "AppTypeFeatures"));

                model = pipeline.Fit(data);

                // Save model
                using (var fs = new FileStream(ModelPath, FileMode.Create, FileAccess.Write, FileShare.Write))
                {
                    mlContext.Model.Save(model, data.Schema, fs);
                }
            }
        }

        private void LoadOrTrainModel()
        {
            if (File.Exists(ModelPath))
            {
                using (var fs = new FileStream(ModelPath, FileMode.Open, FileAccess.Read, FileShare.Read))
                {
                    model = mlContext.Model.Load(fs, out _);
                }
            }
            else
            {
                TrainModel();
            }
        }

        // Recommendation
        public async Task<List<DoctorDTO>> Recommend(int patientId)
        {
            // Load all doctors and prepare all featurized data 
            var allDoctors = await _context.Doctors
                .Include(d => d.DoctorSpecializations)
                    .ThenInclude(ds => ds.Specialization)
                .Include(d => d.User)
                .Include(d => d.Appointments)
                    .ThenInclude(a => a.AppointmentType)
                .Where(d => !d.IsDeleted && d.StateMachine == "active")
                .ToListAsync();

            var allDoctorData = allDoctors.Select(d => new DoctorData
            {
                DoctorId = d.DoctorId,
                Specializations = string.Join(", ", d.DoctorSpecializations.Where(ds => ds.Specialization != null && !ds.Specialization.IsDeleted).Select(ds => ds.Specialization.Name)),
                AppointmentTypes = string.Join(", ", d.Appointments.Where(a => a.AppointmentType != null && !a.AppointmentType.IsDeleted).Select(a => a.AppointmentType.Name).Distinct())
            }).ToList();

            // Gather all doctors from appointment history and favorites 
            var visitedDoctorIds = await _context.Appointments
                .Where(a => a.PatientId == patientId && !a.IsDeleted)
                .Select(a => a.DoctorId)
                .Distinct()
                .ToListAsync();

            var favoriteDoctorIds = await _context.PatientDoctorFavorites
                .Where(fav => fav.PatientId == patientId)
                .Select(fav => fav.DoctorId)
                .Distinct()
                .ToListAsync();

            var allProfileDoctorIds = visitedDoctorIds.Union(favoriteDoctorIds).Distinct().ToList();

            var userDoctorData = allDoctorData.Where(d => allProfileDoctorIds.Contains(d.DoctorId)).ToList();

            //If there is no appointment history or favorites, return top doctors  
            if (userDoctorData.Count == 0)
            {
                var fallback = allDoctors
                    .OrderByDescending(d => d.Appointments.Count(a => !a.IsDeleted))
                    .Take(3)
                    .ToList();
                return _mapper.Map<List<DoctorDTO>>(fallback);
            }

            // Prediction engine
            var predictionEngine = mlContext.Model.CreatePredictionEngine<DoctorData, DoctorPrediction>(model);

            // "User profile" = average from all doctor vectors that patient has visited or favorited  
            var userVectors = userDoctorData.Select(d => predictionEngine.Predict(d).Features).ToList();
            var userProfileVector = AverageVector(userVectors);

            // For each doctor calculate similarity with user profile 
            var predictions = new List<(int doctorId, float score)>();
            foreach (var doc in allDoctorData)
            {
                if (allProfileDoctorIds.Contains(doc.DoctorId)) continue; //Don't recommend those that user has already visited/favored 
                var docVector = predictionEngine.Predict(doc).Features;
                var score = CosineSimilarity(userProfileVector, docVector);
                predictions.Add((doc.DoctorId, score));
            }

            var recommendedDoctorIds = predictions
                .OrderByDescending(x => x.score)
                .Take(3)
                .Select(x => x.doctorId)
                .ToList();

            var recommendedDoctors = allDoctors.Where(d => recommendedDoctorIds.Contains(d.DoctorId)).ToList();
            return _mapper.Map<List<DoctorDTO>>(recommendedDoctors);
        }

        // Helpers

        private float[] AverageVector(List<float[]> vectors)
        {
            if (vectors.Count == 0) return new float[0];
            var length = vectors[0].Length;
            var avg = new float[length];

            foreach (var v in vectors)
                for (int i = 0; i < length; i++)
                    avg[i] += v[i];

            for (int i = 0; i < length; i++)
                avg[i] /= vectors.Count;

            return avg;
        }

        private float CosineSimilarity(float[] v1, float[] v2)
        {
            if (v1.Length != v2.Length) return 0f;
            float dot = 0f, mag1 = 0f, mag2 = 0f;
            for (int i = 0; i < v1.Length; i++)
            {
                dot += v1[i] * v2[i];
                mag1 += v1[i] * v1[i];
                mag2 += v2[i] * v2[i];
            }
            if (mag1 == 0f || mag2 == 0f) return 0f;
            return dot / (float)(Math.Sqrt(mag1) * Math.Sqrt(mag2));
        }
    }
}
