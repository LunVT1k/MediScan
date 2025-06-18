👨‍💻 DocScan – Developer Documentation
✨ About the Project
MediScan is a cutting-edge Flutter application designed for medical institutions. It focuses on intuitive patient data management, vital sign monitoring, and medical appointment scheduling.

🎯 Core Objectives
Efficiency: Fast access to medical and patient data

Clarity: Structured, professional presentation of critical information

Modern Tech: Utilizes Flutter 3, Material 3, and modern animations

User-Friendly: Responsive, accessible, and easy to expand

🚀 Features
👥 Patient Management
Patient list with search and filter capabilities

Detailed profiles with status indicators (Critical, Urgent, Stable)

Allergy and blood type management

📊 Vital Sign Monitoring
Real-time charts for:

Heart Rate (BPM)

Blood Pressure (mmHg)

Body Temperature (°C)

Blood Oxygen Saturation (%)

Timeframes: daily, weekly, monthly

Libraries used: fl_chart, syncfusion_flutter_charts

🗓️ Appointment Scheduling
Monthly calendar with color-coded events:

🔴 Trend checkups

🔵 Follow-ups

🟢 Procedures

🫀 Medical Visualization
Animated heart MRI scans featuring:

Pulse animation

Rotating scan lines

Grid overlay for professional appearance

🎨 Design & UX
Dark mode with Material 3

Glassmorphism effects

Google Fonts integration (Inter)

Consistent medical color palette (AppColors)

🛠️ Technology Stack
Core
Flutter 3.8.1+

Dart

Material 3

State Management
provider: ^6.1.5

Navigation
go_router: ^15.2.0

Charts & Visualization
fl_chart: ^1.0.0

syncfusion_flutter_charts: ^29.2.11

UI & Design
google_fonts: ^6.2.1

flutter_svg: ^2.2.0

Networking & Data
dio: ^5.8.0+1

http: ^1.4.0

shared_preferences: ^2.5.3

Utilities
intl: ^0.20.2

uuid: ^4.5.1

📦 Installation
Requirements
Flutter SDK ≥ 3.8.1

Dart SDK

Android Studio or VS Code

Git

Step-by-Step Setup

bash ///

git clone https://github.com/LunVT1k/docscan.git
cd docscan
flutter pub get
flutter packages pub run build_runner build  # if required
flutter run      # or: flutter run --release
