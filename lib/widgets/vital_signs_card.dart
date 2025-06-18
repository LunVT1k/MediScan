// lib/widgets/vital_signs_card.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme/app_theme.dart';
import '../models/patient_model.dart';

class VitalSignsCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String status;
  final Color statusColor;
  final List<ChartDataPoint> chartData;
  final IconData icon;

  const VitalSignsCard({
    // Alle required Parameters
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.statusColor,
    required this.chartData,
    required this.icon, // KORRIGIERT: super.key als erstes optionales Parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(icon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(title, style: AppTextStyles.vitalLabel),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Value
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTextStyles.vitalValue.copyWith(color: statusColor),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(unit, style: AppTextStyles.vitalUnit),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Chart
            SizedBox(
              height: 80,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSpots(),
                      isCurved: true,
                      color: statusColor,
                      barWidth: 2,
                      // KORRIGIERT: isStroke entfernt (nicht mehr unterstützt)
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: statusColor.withAlpha(26),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: chartData.length.toDouble() - 1,
                  minY: _getMinY(),
                  maxY: _getMaxY(),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Normal range indicator
            Text(_getNormalRangeText(), style: AppTextStyles.vitalLabel),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    return chartData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }

  double _getMinY() {
    if (chartData.isEmpty) return 0;
    final values = chartData.map((e) => e.value).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    return min * 0.9; // Add 10% padding
  }

  double _getMaxY() {
    if (chartData.isEmpty) return 100;
    final values = chartData.map((e) => e.value).toList();
    final max = values.reduce((a, b) => a > b ? a : b);
    return max * 1.1; // Add 10% padding
  }

  String _getNormalRangeText() {
    switch (title) {
      case 'Heart Rate':
        return 'Normal: 60-100 BPM';
      case 'Blood Pressure':
        return 'Normal: 120/80 mmHg';
      case 'Blood Oxygen':
        return 'Normal: 95-100%';
      case 'Temperature':
        return 'Normal: 36.1-37.2°C';
      default:
        return '';
    }
  }
}
