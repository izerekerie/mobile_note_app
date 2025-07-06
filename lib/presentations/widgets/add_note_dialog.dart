import 'package:flutter/material.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Color(0xFF6366F1),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add New Note',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _textController,
                    maxLines: 5,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      hintText: 'Write your note here...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter some text for your note';
                      }
                      return null;
                    },
                    autofocus: true,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_textController.text.length}/500 characters',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop(_textController.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Note',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 