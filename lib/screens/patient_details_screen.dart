// lib/screens/patient_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../providers/patient_provider.dart';
import '../models/patient_model.dart'; // Import hinzugefügt für Typen

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({required this.patientId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          final patient = patientProvider.patients
              .where((p) => p.id == patientId)
              .firstOrNull;

          if (patient == null) {
            return const Center(child: Text('Patient not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Image.asset(
                            'assets/images/megusta.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 40),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient.fullName,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'ID: ${patient.patientId}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    patient.status,
                                  ).withAlpha(51),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  patient.statusText,
                                  style: TextStyle(
                                    color: _getStatusColor(patient.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Patient Information
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          children: [
                            _buildInfoCard('Personal Information', [
                              _buildInfoRow('Age', '${patient.age} years'),
                              _buildInfoRow('Gender', patient.gender),
                              _buildInfoRow(
                                'Blood Type',
                                patient.bloodTypeText,
                              ),
                              _buildInfoRow('Department', patient.department),
                            ]),
                            const SizedBox(height: 16),
                            _buildInfoCard('Medical Information', [
                              _buildInfoRow(
                                'Allergies',
                                patient.allergies.isEmpty
                                    ? 'None'
                                    : patient.allergies.join(', '),
                              ),
                              _buildInfoRow(
                                'Admission Date',
                                '${patient.admissionDate.day}/${patient.admissionDate.month}/${patient.admissionDate.year}',
                              ),
                              _buildInfoRow('Status', patient.statusText),
                            ]),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Right Column
                      Expanded(
                        child: _buildInfoCard(
                          'Recent Vital Signs',
                          patientProvider.vitalSigns
                              .map(
                                (vital) => _buildVitalRow(
                                  vital.timestamp,
                                  vital.heartRate,
                                  vital.bloodPressure,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.vitalLabel),
          ),
          Expanded(child: Text(value, style: AppTextStyles.patientStatus)),
        ],
      ),
    );
  }

  Widget _buildVitalRow(
    DateTime timestamp,
    int heartRate,
    String bloodPressure,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${timestamp.day}/${timestamp.month}',
            style: AppTextStyles.vitalLabel,
          ),
          Text('$heartRate BPM', style: AppTextStyles.patientStatus),
          Text(bloodPressure, style: AppTextStyles.patientStatus),
        ],
      ),
    );
  }

  // KORRIGIERT: Typ-Annotation hinzugefügt
  Color _getStatusColor(PatientStatus status) {
    switch (status) {
      case PatientStatus.critical:
        return AppColors.critical;
      case PatientStatus.urgent:
        return AppColors.urgent;
      case PatientStatus.stable:
        return AppColors.stable;
    }
  }
}
