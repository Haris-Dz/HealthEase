# HealthEase
Seminar project for the course *Software Development 2* at the Faculty of Information Technologies in Mostar

# Setup Instructions
- **Open the HealthEase repository**
- **Navigate to the HealthEase folder within the repository**
- **Locate the archive named fit-build-2025-06-11 - env.zip**
- **Extract the .env file from the archive into the same folder (HealthEase/HealthEase)**
- **The .env file should be located in the HealthEase\HealthEase folder**
- **Inside HealthEase\HealthEase, open a terminal and run the command `docker compose up --build`, then wait for everything to build successfully**
- **Go back to the HealthEase root folder and locate the archives: fit-build-2025-06-12-desktop.zip and fit-build-2025-06-12-mobile.zip**
- **Extract both archives; you should get two folders: Release and flutter-apk**
- **Open the Release folder and run `healthease_desktop.exe`**
- **Open the flutter-apk folder**
- **Transfer the `app-release.apk` file to the emulator and wait for it to install (Uninstall the existing app from the emulator if it was previously installed!)**
- **After both apps are installed, you can log in using the credentials below**

## Login Credentials

### Administrator (desktop app):
- **Username:** `desktop`
- **Password:** `test`

### Doctor (desktop app):
- **Username:** `doctor`
- **Password:** `test`

### Patient (mobile app):
- **Username:** `mobile`
- **Password:** `test`

## PayPal Credentials
- **Email:** `sb-8arsz41900293@personal.example.com`
- **Password:** `HBBb?3Ra`
- **Payment is available on the Appointments screen (mobile) after the appointment has been approved from the desktop application**

## Microservice
- **RabbitMQ is used for sending emails after an administrator adds a new employee via the Users screen on the desktop app**
