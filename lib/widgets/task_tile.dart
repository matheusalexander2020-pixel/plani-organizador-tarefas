import 'package:material_ui/material_ui.dart';
import '../models/task_item.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  final TaskItem task;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = task.isCompleted
        ? const Color(0xFF9B98AA)
        : const Color(0xFF6253EA);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: task.isCompleted ? const Color(0xFFECEBF1) : const Color(0xFFE9E6FF),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080D0A35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox.adaptive(
            value: task.isCompleted,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: const Color(0xFF16B8A6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                color: task.isCompleted ? const Color(0xFFAAA8B5) : const Color(0xFF29263F),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: const Color(0xFFAAA8B5),
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          IconButton(
            tooltip: 'Remover tarefa',
            onPressed: onDelete,
            icon: const Icon(Icons.close_rounded, size: 19),
            color: const Color(0xFFB7B4C2),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
