import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComuneSelectionModal extends ConsumerStatefulWidget {
  const ComuneSelectionModal({super.key});

  @override
  ConsumerState<ComuneSelectionModal> createState() => _ComuneSelectionModalState();
}

class _ComuneSelectionModalState extends ConsumerState<ComuneSelectionModal> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      Navigator.of(context).pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.map_pin),
              const SizedBox(width: 8),
              const Text('Inserisci Comune (senza provincia)'),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Es. Milano',
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }
}