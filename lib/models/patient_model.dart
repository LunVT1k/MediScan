// lib/models/patient_model.dart

enum PatientStatus { critical, urgent, stable }

enum BloodType {
  oNegative,
  oPositive,
  aNegative,
  aPositive,
  bNegative,
  bPositive,
  abNegative,
  abPositive,
}

class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final PatientStatus status;
  final String patientId;
  final BloodType bloodType;
  final List<String> allergies;
  final DateTime admissionDate;
  final String department;
  final String? avatarUrl; // KORRIGIERT: Optional parameter am Ende

  const Patient({
    // KORRIGIERT: Alle required parameter zuerst
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.status,
    required this.patientId,
    required this.bloodType,
    required this.allergies,
    required this.admissionDate,
    required this.department,
    // Optional parameters am Ende
    this.avatarUrl,
  });

  String get fullName => '$firstName $lastName';

  String get statusText {
    switch (status) {
      case PatientStatus.critical:
        return 'CRITICAL';
      case PatientStatus.urgent:
        return 'URGENT';
      case PatientStatus.stable:
        return 'STABLE';
    }
  }

  String get bloodTypeText {
    switch (bloodType) {
      case BloodType.oNegative:
        return 'O Negative';
      case BloodType.oPositive:
        return 'O Positive';
      case BloodType.aNegative:
        return 'A Negative';
      case BloodType.aPositive:
        return 'A Positive';
      case BloodType.bNegative:
        return 'B Negative';
      case BloodType.bPositive:
        return 'B Positive';
      case BloodType.abNegative:
        return 'AB Negative';
      case BloodType.abPositive:
        return 'AB Positive';
    }
  }

  Patient copyWith({
    String? id,
    String? firstName,
    String? lastName,
    int? age,
    String? gender,
    PatientStatus? status,
    String? patientId,
    BloodType? bloodType,
    List<String>? allergies,
    DateTime? admissionDate,
    String? department,
    String? avatarUrl,
  }) {
    return Patient(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      admissionDate: admissionDate ?? this.admissionDate,
      department: department ?? this.department,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class VitalSigns {
  final String patientId;
  final DateTime timestamp;
  final int heartRate;
  final String bloodPressure;
  final double temperature;
  final int bloodOxygen;
  final String notes;

  const VitalSigns({
    required this.patientId,
    required this.timestamp,
    required this.heartRate,
    required this.bloodPressure,
    required this.temperature,
    required this.bloodOxygen,
    this.notes = '',
  });

  VitalSigns copyWith({
    String? patientId,
    DateTime? timestamp,
    int? heartRate,
    String? bloodPressure,
    double? temperature,
    int? bloodOxygen,
    String? notes,
  }) {
    return VitalSigns(
      patientId: patientId ?? this.patientId,
      timestamp: timestamp ?? this.timestamp,
      heartRate: heartRate ?? this.heartRate,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      temperature: temperature ?? this.temperature,
      bloodOxygen: bloodOxygen ?? this.bloodOxygen,
      notes: notes ?? this.notes,
    );
  }
}

class ChartDataPoint {
  final DateTime timestamp;
  final double value;
  final String label;

  const ChartDataPoint({
    required this.timestamp,
    required this.value,
    required this.label,
  });
}
