// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using EasyNetQ.DI;
using System.Net.Sockets;
using HealthEase.Model.Messages;
using HealthEase.Subscriber;
using HealthEase.Subscriber.EmailService;
using DotNetEnv;
var envPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "../../../../.env");
Env.Load(envPath);


DotNetEnv.Env.Load(envPath);



Console.WriteLine("Hello, World!");
string rabbitmqport = Environment.GetEnvironmentVariable("RABBIT_MQ_PORT") ?? string.Empty;
string rabbitmqhost = Environment.GetEnvironmentVariable("RABBIT_MQ_HOST") ?? string.Empty;
Console.WriteLine($"{rabbitmqport}");
await WaitForRabbitMQAsync($"{rabbitmqhost}", int.TryParse(rabbitmqport, out var result) ? result : 0);

string smtpHost = Environment.GetEnvironmentVariable("SMTP_HOST") ?? string.Empty;
int smtpPort = int.TryParse(Environment.GetEnvironmentVariable("SMTP_PORT"), out var port) ? port : 0;
string smtpUser = Environment.GetEnvironmentVariable("SMTP_USER") ?? string.Empty;
string smtpPass = Environment.GetEnvironmentVariable("SMTP_PASS") ?? string.Empty;

string rabbitmq = Environment.GetEnvironmentVariable("RABBIT_MQ") ?? string.Empty;

var emailService = new EmailService(smtpHost, smtpPort, smtpUser, smtpPass);
var bus = RabbitHutch.CreateBus(rabbitmq);
Console.WriteLine($"{rabbitmq}");

bus.PubSub.Subscribe<RegisterMessage>("register_subscriber", async msg=>
{
    string emailBody = $@"
                    <!DOCTYPE html>
                    <html lang='en'>
                    <head>
                        <meta charset='UTF-8'>
                        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                        <title>Welcome to HealthEase</title>
                        <style>
                            body {{
                                font-family: Arial, sans-serif;
                                background-color: #f4f4f4;
                                margin: 0;
                                padding: 20px;
                            }}
                            .container {{
                                background-color: #ffffff;
                                border-radius: 8px;
                                padding: 30px;
                                max-width: 600px;
                                margin: 0 auto;
                                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                            }}
                            h1 {{
                                color: #2c3e50;
                            }}
                            p {{
                                color: #555;
                                line-height: 1.6;
                            }}
                            .credentials {{
                                background-color: #f0f8ff;
                                border-left: 4px solid #3498db;
                                padding: 10px 20px;
                                margin: 20px 0;
                            }}
                            .footer {{
                                font-size: 12px;
                                color: #888;
                                margin-top: 40px;
                            }}
                        </style>
                    </head>
                    <body>
                        <div class='container'>
                            <h1>Welcome to HealthEase, {msg.employeeFirstName}!</h1>
                            <p>
                                Your account has been successfully created. Below you will find your login credentials for accessing the HealthEase platform:
                            </p>

                            <div class='credentials'>
                                <p><strong>Username:</strong> {msg.username}</p>
                                <p><strong>Password:</strong> {msg.password}</p>
                            </div>

                            <p>
                                Please make sure to keep this information secure. Once you log in, we recommend changing your password immediately.
                            </p>

                            <p>
                                If you have any questions or need assistance, feel free to contact our support team.
                            </p>

                            <p>Best regards,<br>The HealthEase Team</p>

                            <div class='footer'>
                                <p>This is an automated message. Please do not reply directly to this email.</p>
                            </div>
                        </div>
                    </body>
                    </html>";
    try
    {
        await emailService.SendEmailAsync(msg.email, "Your HealthEase account has been created", emailBody);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to send email: {ex.Message}");
    }
});

Console.WriteLine("Listening for messages, press <return> key to close!");
Thread.Sleep(Timeout.Infinite);
Console.ReadLine();

async Task WaitForRabbitMQAsync(string host, int port, int maxRetries = 10, int delayMilliseconds = 2000)
{
    for (int i = 0; i < maxRetries; i++)
    {
        try
        {
            using (var client = new TcpClient())
            {
                await client.ConnectAsync(host, port);
                Console.WriteLine("RabbitMQ is up and running!");
                return;
            }
        }
        catch (SocketException)
        {
            Console.WriteLine($"RabbitMQ is not available yet. Retrying in {delayMilliseconds / 1000} seconds...");
            await Task.Delay(delayMilliseconds);
        }
    }

    Console.WriteLine("Failed to connect to RabbitMQ after several attempts.");
    Environment.Exit(1);
}