import 'package:material_ui/material_ui.dart' show Alignment, AppBar, Border, BorderRadius, BorderSide, BoxDecoration, BoxShape, BuildContext, Center, CircleAvatar, CircleBorder, Color, Colors, Column, Container, CrossAxisAlignment, DateUtils, EdgeInsets, Expanded, FloatingActionButton, FontWeight, Icon, IconData, Icons, IndexedStack, InkWell, LinearGradient, Material, NavigationBar, NavigationDestination, OutlinedButton, Padding, RoundedRectangleBorder, Row, SafeArea, Scaffold, SingleChildScrollView, SizedBox, State, StatefulWidget, StatelessWidget, Text, TextAlign, TextButton, TextStyle, ValueChanged, VoidCallback, Widget, showDatePicker;
import '../models/task_item.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/calendar_card.dart';
import '../widgets/task_tile.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key, required this.userName});
  final String userName;

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  int _selectedTab = 0;
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  late DateTime _displayedMonth;
  Map<String, List<TaskItem>> _tasksByDate = {};

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);

    // Exemplos iniciais para demonstrar a organização por status.
    _tasksByDate = {
      dateKey(_selectedDate): [
        const TaskItem(id: 'demo-1', title: 'Organizar prioridades'),
        const TaskItem(id: 'demo-2', title: 'Revisar anotações'),
        const TaskItem(id: 'demo-3', title: 'Tomar café da manhã', isCompleted: true),
      ],
    };
  }

  List<TaskItem> _tasksFor(DateTime date) {
    return List<TaskItem>.from(_tasksByDate[dateKey(date)] ?? const []);
  }

  List<TaskItem> _sortedTasksFor(DateTime date) {
    final tasks = _tasksFor(date);
    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return alphabeticalKey(a.title).compareTo(alphabeticalKey(b.title));
    });
    return tasks;
  }

  Map<String, int> _taskCounts() {
    return _tasksByDate.map((key, value) => MapEntry(key, value.length));
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = DateUtils.dateOnly(date);
      _displayedMonth = DateTime(date.year, date.month);
    });
  }

  void _addTask(String title) {
    final key = dateKey(_selectedDate);
    final current = List<TaskItem>.from(_tasksByDate[key] ?? const []);
    current.add(
      TaskItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
      ),
    );
    setState(() => _tasksByDate = {..._tasksByDate, key: current});
  }

  void _toggleTask(TaskItem task, bool completed) {
    final key = dateKey(_selectedDate);
    final current = _tasksFor(_selectedDate)
        .map((item) => item.id == task.id ? item.copyWith(isCompleted: completed) : item)
        .toList();
    setState(() => _tasksByDate = {..._tasksByDate, key: current});
  }

  void _deleteTask(TaskItem task) {
    final key = dateKey(_selectedDate);
    final current = _tasksFor(_selectedDate)
        .where((item) => item.id != task.id)
        .toList();
    setState(() => _tasksByDate = {..._tasksByDate, key: current});
  }

  Future<void> _showAddTask() async {
    final title = await showAddTaskDialog(context);
    if (title != null && title.trim().isNotEmpty) {
      _addTask(title.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.userName.trim().split(' ').first;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF6253EA),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 19),
            ),
            const SizedBox(width: 9),
            const Text(
              'plani',
              style: TextStyle(color: Color(0xFF29263F), fontWeight: FontWeight.w900, letterSpacing: -0.7),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFFFE5C7),
              child: Text(
                firstName.isEmpty ? 'P' : firstName[0].toUpperCase(),
                style: const TextStyle(color: Color(0xFF9D5C20), fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _CalendarPage(
              firstName: firstName,
              selectedDate: _selectedDate,
              displayedMonth: _displayedMonth,
              taskCounts: _taskCounts(),
              tasks: _tasksFor(_selectedDate),
              onDateSelected: _selectDate,
              onMonthChanged: (month) => setState(() => _displayedMonth = month),
              onOpenTasks: () => setState(() => _selectedTab = 1),
            ),
            _TaskListPage(
              selectedDate: _selectedDate,
              tasks: _sortedTasksFor(_selectedDate),
              onAdd: _showAddTask,
              onToggle: _toggleTask,
              onDelete: _deleteTask,
              onOpenCalendar: () => setState(() => _selectedTab = 0),
              onPickDate: _selectDate,
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedTab == 1
          ? FloatingActionButton.extended(
              onPressed: _showAddTask,
              backgroundColor: const Color(0xFF6253EA),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nova tarefa', style: TextStyle(fontWeight: FontWeight.w800)),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Calendário',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            selectedIcon: Icon(Icons.task_alt_rounded),
            label: 'Tarefas',
          ),
        ],
      ),
    );
  }
}

class _CalendarPage extends StatelessWidget {
  const _CalendarPage({
    required this.firstName,
    required this.selectedDate,
    required this.displayedMonth,
    required this.taskCounts,
    required this.tasks,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.onOpenTasks,
  });

  final String firstName;
  final DateTime selectedDate;
  final DateTime displayedMonth;
  final Map<String, int> taskCounts;
  final List<TaskItem> tasks;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChanged;
  final VoidCallback onOpenTasks;

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((task) => task.isCompleted).length;
    final pending = tasks.length - completed;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, $firstName! 👋',
            style: const TextStyle(fontSize: 25, color: Color(0xFF29263F), fontWeight: FontWeight.w900, letterSpacing: -0.8),
          ),
          const SizedBox(height: 5),
          const Text(
            'Um passo de cada vez. Seu dia começa aqui.',
            style: TextStyle(color: Color(0xFF9996A8), fontSize: 13),
          ),
          const SizedBox(height: 21),
          const _SectionEyebrow(label: 'SEU PLANEJAMENTO'),
          const SizedBox(height: 10),
          CalendarCard(
            selectedDate: selectedDate,
            displayedMonth: displayedMonth,
            taskCounts: taskCounts,
            onDateSelected: onDateSelected,
            onMonthChanged: onMonthChanged,
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Pendentes',
                  value: '$pending',
                  icon: Icons.hourglass_bottom_rounded,
                  accent: const Color(0xFFFFA63D),
                  pale: const Color(0xFFFFF2E1),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _StatCard(
                  label: 'Concluídas',
                  value: '$completed',
                  icon: Icons.check_circle_outline_rounded,
                  accent: const Color(0xFF16B8A6),
                  pale: const Color(0xFFE1F8F4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6253EA), Color(0xFF8175FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dia em foco', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text('Veja e organize suas tarefas.', style: TextStyle(color: Color(0xFFE4E1FF), fontSize: 11)),
                    ],
                  ),
                ),
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onOpenTasks,
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(Icons.arrow_forward_rounded, color: Color(0xFF6253EA)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskListPage extends StatelessWidget {
  const _TaskListPage({
    required this.selectedDate,
    required this.tasks,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
    required this.onOpenCalendar,
    required this.onPickDate,
  });

  final DateTime selectedDate;
  final List<TaskItem> tasks;
  final VoidCallback onAdd;
  final void Function(TaskItem, bool) onToggle;
  final ValueChanged<TaskItem> onDelete;
  final VoidCallback onOpenCalendar;
  final ValueChanged<DateTime> onPickDate;

  Future<void> _chooseDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'Escolha o dia das tarefas',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );
    if (picked != null) onPickDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final pending = tasks.where((task) => !task.isCompleted).toList();
    final completed = tasks.where((task) => task.isCompleted).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionEyebrow(label: 'ORGANIZE SUA ROTINA'),
          const SizedBox(height: 7),
          const Text(
            'Lista de tarefas',
            style: TextStyle(color: Color(0xFF29263F), fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.8),
          ),
          const SizedBox(height: 14),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _chooseDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEBFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_rounded, color: Color(0xFF6253EA), size: 19),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      formatDateLong(selectedDate),
                      style: const TextStyle(color: Color(0xFF5144C9), fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6253EA)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 21),
          Row(
            children: [
              const Expanded(
                child: Text('O que vamos fazer?', style: TextStyle(color: Color(0xFF29263F), fontSize: 17, fontWeight: FontWeight.w800)),
              ),
              Text('${tasks.length} ${tasks.length == 1 ? 'tarefa' : 'tarefas'}', style: const TextStyle(color: Color(0xFF9B98A9), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          if (tasks.isEmpty)
            _EmptyTasks(onAdd: onAdd)
          else ...[
            if (pending.isNotEmpty) ...[
              _GroupHeading(title: 'PENDENTES', count: pending.length, color: const Color(0xFFFFA63D)),
              const SizedBox(height: 9),
              ...pending.map(
                (task) => TaskTile(
                  task: task,
                  onChanged: (value) => onToggle(task, value),
                  onDelete: () => onDelete(task),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (completed.isNotEmpty) ...[
              _GroupHeading(title: 'CONCLUÍDAS', count: completed.length, color: const Color(0xFF16B8A6)),
              const SizedBox(height: 9),
              ...completed.map(
                (task) => TaskTile(
                  task: task,
                  onChanged: (value) => onToggle(task, value),
                  onDelete: () => onDelete(task),
                ),
              ),
            ],
          ],
          const SizedBox(height: 12),
          if (tasks.isNotEmpty)
            Center(
              child: TextButton.icon(
                onPressed: onOpenCalendar,
                icon: const Icon(Icons.calendar_month_outlined, size: 17),
                label: const Text('Voltar ao calendário'),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFF6253EA)),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDEBF5)),
      ),
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(color: Color(0xFFF0EEFF), shape: BoxShape.circle),
            child: const Icon(Icons.spa_rounded, color: Color(0xFF7668F5), size: 30),
          ),
          const SizedBox(height: 13),
          const Text('Tudo começa com um plano', style: TextStyle(color: Color(0xFF343149), fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 6),
          const Text('Adicione sua primeira tarefa para este dia.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF9A97A8), fontSize: 12)),
          const SizedBox(height: 15),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Adicionar tarefa'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6253EA),
              side: const BorderSide(color: Color(0xFFD8D3FF)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupHeading extends StatelessWidget {
  const _GroupHeading({required this.title, required this.count, required this.color});
  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 7),
        Text(title, style: const TextStyle(color: Color(0xFF8E8B9C), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(width: 7),
        Text('$count', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _SectionEyebrow extends StatelessWidget {
  const _SectionEyebrow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Color(0xFF8D89A4), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.4),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    required this.pale,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final Color pale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEBF5)),
      ),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Color(0xFF29263F), fontSize: 19, fontWeight: FontWeight.w900)),
                Text(label, style: const TextStyle(color: Color(0xFF9A97A8), fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
