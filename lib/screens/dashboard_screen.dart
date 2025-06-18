// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/patient_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/patient_card.dart';
import '../widgets/vital_signs_card.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/cardiac_scan_widget.dart';
import '../widgets/patient_health_trends.dart';
import '../models/patient_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: AppColors.surface,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MEDISCAN',
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'v2.3.4',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation Tabs
                Consumer<DashboardProvider>(
                  builder: (context, dashboardProvider, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton(
                            'Vitals',
                            DashboardTab.vitals,
                            dashboardProvider.currentTab == DashboardTab.vitals,
                            () => dashboardProvider.setTab(DashboardTab.vitals),
                          ),
                          _buildTabButton(
                            'Meds',
                            DashboardTab.medications,
                            dashboardProvider.currentTab ==
                                DashboardTab.medications,
                            () => dashboardProvider.setTab(
                              DashboardTab.medications,
                            ),
                          ),
                          _buildTabButton(
                            'History',
                            DashboardTab.history,
                            dashboardProvider.currentTab ==
                                DashboardTab.history,
                            () =>
                                dashboardProvider.setTab(DashboardTab.history),
                          ),
                          _buildTabButton(
                            'Diag',
                            DashboardTab.diagnostics,
                            dashboardProvider.currentTab ==
                                DashboardTab.diagnostics,
                            () => dashboardProvider.setTab(
                              DashboardTab.diagnostics,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Patient List
                Expanded(
                  child: Consumer<PatientProvider>(
                    builder: (context, patientProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patients',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Search',
                                      prefixIcon: Icon(Icons.search, size: 18),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Patient Cards
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: patientProvider.patients.length,
                              itemBuilder: (context, index) {
                                final patient = patientProvider.patients[index];
                                return PatientCard(
                                  patient: patient,
                                  isSelected:
                                      patientProvider.selectedPatient?.id ==
                                      patient.id,
                                  onTap: () =>
                                      patientProvider.selectPatient(patient),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Consumer2<PatientProvider, DashboardProvider>(
                builder: (context, patientProvider, dashboardProvider, child) {
                  return Column(
                    children: [
                      // Top Bar
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Patient Info
                            if (patientProvider.selectedPatient != null)
                              Expanded(
                                child: _buildPatientHeader(
                                  patientProvider.selectedPatient!,
                                ),
                              ),

                            // Actions
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.mail_outline),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 20,
                                  child: Image.asset(
                                    'assets/images/megusta.png',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.person),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Content Area
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: _buildTabContent(
                            dashboardProvider.currentTab,
                            patientProvider,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String title,
    DashboardTab tab,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientHeader(Patient patient) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          child: Image.asset(
            'assets/images/megusta.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.person),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(patient.fullName, style: AppTextStyles.patientName),
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      '${patient.age} Years',
                      style: AppTextStyles.patientStatus,
                    ),
                    const SizedBox(width: 16),
                    Text(patient.gender, style: AppTextStyles.patientStatus),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getPatientStatusColor(
                          patient.status,
                        ).withAlpha(51),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        patient.statusText,
                        style: _getPatientStatusTextStyle(patient.status),
                      ),
                    ),
                    const SizedBox(width: 24),
                    _buildInfoItem('Patient ID', patient.patientId),
                    const SizedBox(width: 24),
                    _buildInfoItem('Blood Type', patient.bloodTypeText),
                    const SizedBox(width: 24),
                    _buildInfoItem(
                      'Allergies',
                      patient.allergies.isEmpty
                          ? 'None'
                          : patient.allergies.join(', '),
                    ),
                    const SizedBox(width: 24),
                    _buildInfoItem('Admission', 'June 12, 2025'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.vitalLabel),
        Text(value, style: AppTextStyles.patientStatus),
      ],
    );
  }

  Color _getPatientStatusColor(PatientStatus status) {
    switch (status) {
      case PatientStatus.critical:
        return AppColors.critical;
      case PatientStatus.urgent:
        return AppColors.urgent;
      case PatientStatus.stable:
        return AppColors.stable;
    }
  }

  TextStyle _getPatientStatusTextStyle(PatientStatus status) {
    switch (status) {
      case PatientStatus.critical:
        return AppTextStyles.criticalStatus;
      case PatientStatus.urgent:
        return AppTextStyles.urgentStatus;
      case PatientStatus.stable:
        return AppTextStyles.stableStatus;
    }
  }

  Widget _buildTabContent(DashboardTab tab, PatientProvider patientProvider) {
    switch (tab) {
      case DashboardTab.vitals:
        return _buildVitalsContent(patientProvider);
      case DashboardTab.medications:
        return _buildMedicationsContent();
      case DashboardTab.history:
        return _buildHistoryContent();
      case DashboardTab.diagnostics:
        return _buildDiagnosticsContent();
    }
  }

  Widget _buildVitalsContent(PatientProvider patientProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column - Vital Signs
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Vital Signs Cards
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: VitalSignsCard(
                        title: 'Heart Rate',
                        value: '118',
                        unit: 'BPM',
                        status: 'ELEVATED',
                        statusColor: AppColors.heartRate,
                        chartData: patientProvider.getHeartRateData(),
                        icon: Icons.favorite,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: VitalSignsCard(
                        title: 'Blood Pressure',
                        value: '145/95',
                        unit: 'mmHg',
                        status: 'HYPERTENSIVE',
                        statusColor: AppColors.bloodPressure,
                        chartData: patientProvider.getHeartRateData(),
                        icon: Icons.speed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Expanded(
                child: Row(
                  children: [
                    Expanded(child: CalendarWidget()),
                    SizedBox(width: 16),
                    Expanded(child: CardiacScanWidget()),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Right Column - Health Trends
        const Expanded(flex: 1, child: PatientHealthTrends()),
      ],
    );
  }

  Widget _buildMedicationsContent() {
    return const Center(
      child: Text(
        'Medications Content',
        style: TextStyle(fontSize: 24, color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildHistoryContent() {
    return const Center(
      child: Text(
        'History Content',
        style: TextStyle(fontSize: 24, color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildDiagnosticsContent() {
    return const Center(
      child: Text(
        'Diagnostics Content',
        style: TextStyle(fontSize: 24, color: AppColors.textMuted),
      ),
    );
  }
}
