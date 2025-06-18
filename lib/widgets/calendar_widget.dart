// lib/widgets/calendar_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16), // Reduziert von 20
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar Header - KORRIGIERT: Responsive Layout
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Calendar', // Verkürzt von 'Appointment Calendar'
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16, // Kleinere Schrift
                        ),
                      ),
                    ),
                    // Navigation Buttons - kompakter
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: provider.previousMonth,
                          icon: const Icon(Icons.chevron_left, size: 20),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        Flexible(
                          child: Text(
                            provider.getMonthName(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: provider.nextMonth,
                          icon: const Icon(Icons.chevron_right, size: 20),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12), // Reduziert von 20
                // Calendar Grid - KORRIGIERT: Flexible Layout
                Expanded(child: _buildCalendarGrid(context, provider)),

                const SizedBox(height: 12), // Reduziert von 16
                // Legend - KORRIGIERT: Responsive Layout
                _buildLegend(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarGrid(BuildContext context, DashboardProvider provider) {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final calendarDays = provider.getCalendarDays();
    final firstDayOfWeek = provider.getFirstDayOfWeek();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Berechne verfügbaren Platz für Kalender-Zellen
        final cellWidth = constraints.maxWidth / 7;
        final cellHeight =
            (constraints.maxHeight - 30) / 6; // 30px für Wochentag-Header
        final _ = cellHeight < cellWidth ? cellHeight : cellWidth;

        return Column(
          children: [
            // Weekday headers
            Row(
              children: days
                  .map(
                    (day) => Expanded(
                      child: Container(
                        height: 24,
                        alignment: Alignment.center,
                        child: Text(
                          day,
                          style: AppTextStyles.vitalLabel.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 4),

            // Calendar days - KORRIGIERT: Flexible Größe
            Expanded(
              child: Column(
                children: List.generate(6, (weekIndex) {
                  return Expanded(
                    child: Row(
                      children: List.generate(7, (dayIndex) {
                        final dayNumber =
                            weekIndex * 7 + dayIndex - firstDayOfWeek + 1;

                        if (dayNumber < 1 || dayNumber > calendarDays.length) {
                          return const Expanded(child: SizedBox());
                        }

                        final hasAppointment = provider.hasAppointment(
                          dayNumber,
                        );
                        final appointmentType = provider.getAppointmentType(
                          dayNumber,
                        );

                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: hasAppointment
                                  ? _getAppointmentColor(appointmentType)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                dayNumber.toString(),
                                style: TextStyle(
                                  color: hasAppointment
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontWeight: hasAppointment
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  fontSize: 10, // Kleinere Schrift
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegend() {
    return Wrap(
      // KORRIGIERT: Wrap statt Row für bessere Responsiveness
      spacing: 8,
      runSpacing: 4,
      children: [
        _buildLegendItem('Trends', AppColors.critical),
        _buildLegendItem('Follow-up', AppColors.info),
        _buildLegendItem('Procedure', AppColors.success),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6, // Kleinere Indikatoren
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTextStyles.vitalLabel.copyWith(
            fontSize: 9,
          ), // Kleinere Schrift
        ),
      ],
    );
  }

  Color _getAppointmentColor(String type) {
    switch (type) {
      case 'trends':
        return AppColors.critical;
      case 'followup':
        return AppColors.info;
      case 'procedure':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }
}
