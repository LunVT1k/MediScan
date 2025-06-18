// lib/widgets/patient_card.dart
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../core/theme/app_theme.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final bool isSelected;
  final VoidCallback? onTap;

  const PatientCard({
    super.key,
    required this.patient,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        color: isSelected
            ? AppColors.primary.withAlpha(26)
            : AppColors.cardBackground,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Patient Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getStatusColor(patient.status),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: patient.avatarUrl != null
                        ? Image.network(
                            patient.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildAvatarPlaceholder(),
                          )
                        : _buildAvatarPlaceholder(),
                  ),
                ),

                const SizedBox(width: 10),
                // Patient Info - Optimized Layout
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        patient.fullName,
                        style: AppTextStyles.patientName.copyWith(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 3),
                      // Optimized layout without Flexible in Wrap
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                patient.status,
                              ).withAlpha(51),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              patient.statusText,
                              style: _getStatusTextStyle(
                                patient.status,
                              ).copyWith(fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              patient.department,
                              style: AppTextStyles.patientStatus.copyWith(
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Image.asset(
      'assets/images/megusta.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.surface,
        child: const Icon(Icons.person, color: AppColors.textMuted, size: 20),
      ),
    );
  }

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

  TextStyle _getStatusTextStyle(PatientStatus status) {
    switch (status) {
      case PatientStatus.critical:
        return AppTextStyles.criticalStatus;
      case PatientStatus.urgent:
        return AppTextStyles.urgentStatus;
      case PatientStatus.stable:
        return AppTextStyles.stableStatus;
    }
  }
}
