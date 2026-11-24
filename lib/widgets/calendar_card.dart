import 'package:material_ui/material_ui.dart';
import '../models/task_item.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({
    super.key,
    required this.selectedDate,
    required this.displayedMonth,
    required this.taskCounts,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  final DateTime selectedDate;
  final DateTime displayedMonth;
  final Map<String, int> taskCounts;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final offset = firstDay.weekday - 1;
    final gridStart = firstDay.subtract(Duration(days: offset));
    const weekDays = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFEDEBF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x090D0A35),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, color: Color(0xFF6253EA)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  formatMonthYear(displayedMonth),
                  style: const TextStyle(
                    color: Color(0xFF29263F),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _MonthButton(
                icon: Icons.chevron_left_rounded,
                onPressed: () => onMonthChanged(DateTime(displayedMonth.year, displayedMonth.month - 1)),
              ),
              const SizedBox(width: 7),
              _MonthButton(
                icon: Icons.chevron_right_rounded,
                onPressed: () => onMonthChanged(DateTime(displayedMonth.year, displayedMonth.month + 1)),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: weekDays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: Color(0xFFA5A2B2),
                          fontSize: 9,
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 9),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 3,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, index) {
              final date = gridStart.add(Duration(days: index));
              final isCurrentMonth = date.month == displayedMonth.month;
              final isSelected = date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;
              final today = DateUtils.isSameDay(date, DateTime.now());
              final taskCount = taskCounts[dateKey(date)] ?? 0;

              return InkWell(
                borderRadius: BorderRadius.circular(13),
                onTap: () => onDateSelected(DateUtils.dateOnly(date)),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6253EA) : Colors.transparent,
                    borderRadius: BorderRadius.circular(13),
                    border: today && !isSelected
                        ? Border.all(color: const Color(0xFF16B8A6), width: 1.3)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isCurrentMonth ? const Color(0xFF39364E) : const Color(0xFFD0CED8)),
                          fontSize: 13,
                          fontWeight: isSelected || today ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: taskCount == 0
                              ? Colors.transparent
                              : (isSelected ? const Color(0xFFB9F6EF) : const Color(0xFF16B8A6)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(color: Color(0xFF16B8A6), shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              const Text(
                'Dia com tarefas',
                style: TextStyle(color: Color(0xFF9A97A8), fontSize: 10, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Text(
                'Hoje',
                style: TextStyle(color: Color(0xFF16A99A), fontSize: 10, fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 6),
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF16B8A6), width: 1.2),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F0FF),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onPressed,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, color: const Color(0xFF6253EA), size: 21),
        ),
      ),
    );
  }
}
