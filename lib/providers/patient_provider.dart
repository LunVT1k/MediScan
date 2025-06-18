// lib/providers/patient_provider.dart
import 'package:flutter/foundation.dart';
import '../models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  Patient? _selectedPatient;
  List<Patient> _patients = [];
  List<VitalSigns> _vitalSigns = [];
  bool _isLoading = false;

  // Getters
  Patient? get selectedPatient => _selectedPatient;
  List<Patient> get patients => List.unmodifiable(_patients);
  List<VitalSigns> get vitalSigns => List.unmodifiable(_vitalSigns);
  bool get isLoading => _isLoading;

  PatientProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _patients = [
      // KORRIGIERT: Parameter-Reihenfolge angepasst
      Patient(
        id: '1',
        firstName: 'Sophia',
        lastName: 'Reynolds',
        age: 43,
        gender: 'Female',
        status: PatientStatus.critical,
        patientId: 'SR-9385-7622',
        bloodType: BloodType.oNegative,
        allergies: ['Penicillin', 'Latex'],
        admissionDate: DateTime(2025, 6, 12),
        department: 'Cardiac',
        // Optional parameter am Ende
      ),
      Patient(
        id: '2',
        firstName: 'James',
        lastName: 'Wilson',
        age: 35,
        gender: 'Male',
        status: PatientStatus.stable,
        patientId: 'JW-7421-9853',
        bloodType: BloodType.aPositive,
        allergies: [],
        admissionDate: DateTime(2025, 6, 10),
        department: 'Post-op',
      ),
      Patient(
        id: '3',
        firstName: 'Emma',
        lastName: 'Thompson',
        age: 28,
        gender: 'Female',
        status: PatientStatus.stable,
        patientId: 'ET-5639-1847',
        bloodType: BloodType.bPositive,
        allergies: ['Aspirin'],
        admissionDate: DateTime(2025, 6, 14),
        department: 'Checkup',
      ),
      Patient(
        id: '4',
        firstName: 'Michael',
        lastName: 'Chen',
        age: 52,
        gender: 'Male',
        status: PatientStatus.urgent,
        patientId: 'MC-8274-5691',
        bloodType: BloodType.abNegative,
        allergies: ['Sulfa'],
        admissionDate: DateTime(2025, 6, 13),
        department: 'Respiratory',
      ),
      Patient(
        id: '5',
        firstName: 'Olivia',
        lastName: 'Martinez',
        age: 31,
        gender: 'Female',
        status: PatientStatus.stable,
        patientId: 'OM-3698-7415',
        bloodType: BloodType.oPositive,
        allergies: [],
        admissionDate: DateTime(2025, 6, 11),
        department: 'Prenatal',
      ),
      Patient(
        id: '6',
        firstName: 'Daniel',
        lastName: 'Johnson',
        age: 67,
        gender: 'Male',
        status: PatientStatus.stable,
        patientId: 'DJ-1592-8364',
        bloodType: BloodType.aPositive,
        allergies: ['Iodine'],
        admissionDate: DateTime(2025, 6, 9),
        department: 'Orthopedic',
      ),
    ];

    // Mock vital signs for selected patient
    _vitalSigns = _generateMockVitalSigns('1');
    _selectedPatient = _patients.first;
    notifyListeners();
  }

  List<VitalSigns> _generateMockVitalSigns(String patientId) {
    final now = DateTime.now();
    return List.generate(7, (index) {
      return VitalSigns(
        patientId: patientId,
        timestamp: now.subtract(Duration(days: 6 - index)),
        heartRate: 110 + (index * 2) + (index % 2 == 0 ? 5 : -5),
        bloodPressure: '145/95',
        temperature: 36.5 + (index * 0.1),
        bloodOxygen: 95 + (index % 3),
      );
    });
  }

  void selectPatient(Patient patient) {
    _selectedPatient = patient;
    _vitalSigns = _generateMockVitalSigns(patient.id);
    notifyListeners();
  }

  Future<void> refreshPatients() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  List<Patient> getPatientsByStatus(PatientStatus status) {
    return _patients.where((patient) => patient.status == status).toList();
  }

  List<ChartDataPoint> getHeartRateData() {
    return _vitalSigns.map((vital) => ChartDataPoint(
      timestamp: vital.timestamp,
      value: vital.heartRate.toDouble(),
      label: 'Heart Rate',
    )).toList();
  }

  List<ChartDataPoint> getBloodOxygenData() {
    return _vitalSigns.map((vital) => ChartDataPoint(
      timestamp: vital.timestamp,
      value: vital.bloodOxygen.toDouble(),
      label: 'Blood Oxygen',
    )).toList();
  }

  List<ChartDataPoint> getTemperatureData() {
    return _vitalSigns.map((vital) => ChartDataPoint(
      timestamp: vital.timestamp,
      value: vital.temperature,
      label: 'Temperature',
    )).toList();
  }
}