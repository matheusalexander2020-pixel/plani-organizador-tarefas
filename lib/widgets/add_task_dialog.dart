import 'package:material_ui/material_ui.dart';

Future<String?> showAddTaskDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _AddTaskDialog(),
  );
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // O controlador é liberado junto com o próprio diálogo, após o fechamento
    // da rota, evitando descartá-lo enquanto o TextField ainda está na árvore.
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    Navigator.of(context).pop(title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        'Nova tarefa',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF29263F),
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(
          hintText: 'Ex.: estudar Flutter',
          prefixIcon: Icon(Icons.edit_note_rounded),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Adicionar'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6253EA),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
