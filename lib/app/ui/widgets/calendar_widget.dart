import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart' as AppDimens;
import 'package:flutter/material.dart';

class Event {
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Event({required this.title, required this.startTime, required this.endTime});
}

class CalendarWidget extends StatefulWidget {
  final void Function(DateTime selectedDate)? onDateSelected;
  final Map<DateTime, List<Event>> events;

  /// ماهِ پایه برای چیپ‌ها (اختیاری). اگر null باشه از DateTime.now() استفاده می‌شه.
  final DateTime? baseMonth;

  const CalendarWidget({Key? key, this.onDateSelected, this.events = const {}, this.baseMonth}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late final DateTime _baseMonth; // برای چیپ‌ها ثابت نگه داشته میشه
  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDate;

  final List<String> _weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  @override
  void initState() {
    super.initState();
    // مقداردهی baseMonth ثابت (چیپ‌ها از روی این محاسبه می‌شن و بعدا تغییر نمیکنن)
    final bm = widget.baseMonth ?? DateTime.now();
    _baseMonth = DateTime(bm.year, bm.month, 1);
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  bool _isSameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

  void _changeMonth(DateTime newMonth) {
    setState(() => _focusedMonth = DateTime(newMonth.year, newMonth.month, 1));
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekDay = firstDay.weekday % 7; // Sunday = 0
    final today = DateTime.now();

    final List<Widget> dayCells = [];
    for (int i = 0; i < firstWeekDay; i++) {
      dayCells.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);

      final isSelected = _selectedDate != null && _isSameMonth(_selectedDate!, date) && _selectedDate!.day == date.day;
      final isToday = today.year == date.year && today.month == date.month && today.day == date.day;

      final List<Event> events = widget.events.keys
          .where((d) => d.year == date.year && d.month == date.month && d.day == date.day)
          .expand((d) => widget.events[d]!)
          .toList();

      List<Widget> eventIndicators = [];
      const int maxDots = 4;
      if (events.length <= maxDots) {
        eventIndicators = events.map((e) => _buildDot()).toList();
      } else {
        final int extra = events.length - maxDots + 1;
        eventIndicators = events.take(maxDots - 1).map((e) => _buildDot()).toList();
        eventIndicators.add(_buildDotWithPlus(extra));
      }

      dayCells.add(
        GestureDetector(
          onTap: () {
            setState(() => _selectedDate = date);
            widget.onDateSelected?.call(date);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isToday
                  ? Theme.of(context).primaryColor.withAlpha(50)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$day",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                if (events.isNotEmpty) Row(mainAxisAlignment: MainAxisAlignment.center, children: eventIndicators),
              ],
            ),
          ),
        ),
      );
    }

    final remainder = dayCells.length % 7;
    if (remainder != 0) {
      for (int i = 0; i < 7 - remainder; i++) {
        dayCells.add(Container());
      }
    }

    // selected events
    List<Event> selectedEvents = [];
    if (_selectedDate != null) {
      widget.events.forEach((key, value) {
        if (key.year == _selectedDate!.year && key.month == _selectedDate!.month && key.day == _selectedDate!.day) {
          selectedEvents = value;
        }
      });
    }

    return Column(
      children: [
        _buildMonthHeader(),
        const SizedBox(height: 8),
        // Weekdays
        Row(
          children: _weekDays
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(d, style: const TextStyle(fontWeight: FontWeight.w400)),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),
        // Days grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: 1,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          children: dayCells,
        ),
        // Events
       /* if (selectedEvents.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Events:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...selectedEvents.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• ${e.title} (${_formatTime(e.startTime)} - ${_formatTime(e.endTime)})"),
                  ),
                ),
              ],
            ),
          ),*/
      ],
    );
  }

  Widget _buildMonthHeader() {
    final now = DateTime.now();
    final baseMonth = DateTime(now.year, now.month, 1);
    final previousMonth = DateTime(baseMonth.year, baseMonth.month - 1, 1);
    final nextMonth = DateTime(baseMonth.year, baseMonth.month + 1, 1);

    final canGoPrev = _focusedMonth.isAfter(previousMonth);
    final canGoNext = _focusedMonth.isBefore(nextMonth);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Theme.of(context).colorScheme.outline, width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // دکمه قبلی
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: canGoPrev
                      ? () {
                    setState(() => _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1));
                  }
                      : null,
                ),

                // نام ماه و سال
                Text(
                  _getMonthName(_focusedMonth.month) /*+ ' ${_focusedMonth.year}'*/,
                  style: Theme.of(context).textTheme.labelMedium,
                ),

                // دکمه بعدی
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: canGoNext
                      ? () {
                    setState(() => _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1));
                  }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
    );
  }

  Widget _buildDotWithPlus(int extra) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        "+$extra",
        style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
