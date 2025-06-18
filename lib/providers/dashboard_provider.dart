// lib/providers/dashboard_provider.dart
import 'package:flutter/foundation.dart';

enum DashboardTab { vitals, medications, history, diagnostics }

enum ChartTimeframe { daily, weekly, monthly }

class DashboardProvider extends ChangeNotifier {
  DashboardTab _currentTab = DashboardTab.vitals;
  ChartTimeframe _currentTimeframe = ChartTimeframe.daily;
  DateTime _selectedDate = DateTime.now();

  // Getters
  DashboardTab get currentTab => _currentTab;
  ChartTimeframe get currentTimeframe => _currentTimeframe;
  DateTime get selectedDate => _selectedDate;

  String get currentTabName {
    switch (_currentTab) {
      case DashboardTab.vitals:
        return 'Vitals';
      case DashboardTab.medications:
        return 'Medications';
      case DashboardTab.history:
        return 'History';
      case DashboardTab.diagnostics:
        return 'Diagnostics';
    }
  }

  String get currentTimeframeName {
    switch (_currentTimeframe) {
      case ChartTimeframe.daily:
        return 'Daily';
      case ChartTimeframe.weekly:
        return 'Weekly';
      case ChartTimeframe.monthly:
        return 'Monthly';
    }
  }

  void setTab(DashboardTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  void setTimeframe(ChartTimeframe timeframe) {
    if (_currentTimeframe != timeframe) {
      _currentTimeframe = timeframe;
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }

  // Calendar navigation
  void previousMonth() {
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    notifyListeners();
  }

  // Get calendar month name
  String getMonthName() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[_selectedDate.month - 1]} ${_selectedDate.year}';
  }

  // Get calendar days for the current month
  List<int> getCalendarDays() {
    final _ = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDay = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    return List.generate(lastDay.day, (index) => index + 1);
  }

  // Get the day of week for the first day of the month (0 = Sunday)
  int getFirstDayOfWeek() {
    final firstDay = DateTime(_selectedDate.year, _selectedDate.month, 1);
    return firstDay.weekday % 7; // Convert to 0-6 where 0 = Sunday
  }

  // Check if a day has appointments/events
  bool hasAppointment(int day) {
    // Mock data - in real app, this would check actual appointments
    final specialDays = [12, 14, 17];
    return specialDays.contains(day);
  }

  // Get appointment type for a day
  String getAppointmentType(int day) {
    // Mock data
    switch (day) {
      case 12:
        return 'followup';
      case 14:
        return 'procedure';
      case 17:
        return 'trends';
      default:
        return '';
    }
  }
}

