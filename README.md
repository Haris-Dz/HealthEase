# HealthEase
Seminarski rad iz predmeta Razvoj softvera 2 na Fakultetu informacijskih tehnologija u Mostaru

# Upute za pokretanje
- **Otvoriti HealthEase repozitorij**
- **Otvoriti folder HealthEase unutar pomenutog repozitorija**
- **Locirati fit-build-2025-06-11 - env.zip arhivu**
- **Iz te arhive uraditi extract .env file-a u istom folderu (HealthEase/HealthEase)**
- **.env file treba biti u HealthEase\HealthEase folderu**
- **Unutar HealthEase\HealthEase, otvoriti terminal i pokrenuti komandu docker compose up --build, te sačekati da se sve uspješno build-a.**
- **Vratiti se u HealthEase root folder i locirati fit-build-2025-06-12-desktop.zip i fit-build-2025-06-12-mobile.zip arhive**
- **Iz tih arhiva uraditi extract, gdje biste trebali dobiti dva foldera: Release i flutter-apk.**
- **Otvoriti Release folder i iz njega otvoriti healthease_desktop.exe**
- **Otvoriti flutter-apk folder**
- **File app-release.apk prenijeti na emulator i sačekati da se instalira. (Deinstalirati aplikaciju sa emulatora ukoliko je prije bila instalirana!)**
- **Nakon instaliranja obe aplikacije, na iste se možete prijaviti koristeći kredencijale ispod.**

## Kredencijali za prijavu

### Administrator (desktop aplikacija):
- **Korisničko ime:** `desktop`
- **Lozinka:** `test`

### Doktor (desktop aplikacija):
- **Korisničko ime:** `doctor`
- **Lozinka:** `test`

### Pacijent (mobilna aplikacija):
- **Korisničko ime:** `mobile`
- **Lozinka:** `test`

## PayPal Kredencijali
- **Email:** `sb-8arsz41900293@personal.example.com`
- **Lozinka:** `HBBb?3Ra`
- **Plaćanje je omogućeno na ekranu Appointments(mobile) nakon sto se appointment odobri sa desktop aplikacije**

## Mikroservis
- **Rabbitmq je iskorišten za slanje mailova nakon što administrator dodaje novog zaposlenika na desktopu na ekranu Users** 
  
