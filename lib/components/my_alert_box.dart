import 'package:flutter/material.dart';

class MyAlertBox extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<MyAlertBox> createState() => _MyAlertBoxState();
}

class _MyAlertBoxState extends State<MyAlertBox> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Neutral backgrounds
    final dialogColor = isDark ? scheme.surface : Colors.white;
    final fieldFillColor = isDark
        ? Colors.grey[850]!
        : const Color(0xFFF2F2F7);

    return AlertDialog(
      backgroundColor: dialogColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: widget.controller,
              style: TextStyle(color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: widget.hintText,
                // ignore: deprecated_member_use
                hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.6)),
                filled: true,
                fillColor: fieldFillColor,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      // ignore: deprecated_member_use
                      BorderSide(color: scheme.outline.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      // ignore: deprecated_member_use
                      BorderSide(color: scheme.outline.withOpacity(0.5), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: scheme.error),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Can't be empty";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.onCancel,
              style: TextButton.styleFrom(
                foregroundColor: scheme.error, // red for cancel
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSave();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? Colors.white : Colors.black, // neutral button
                foregroundColor:
                    isDark ? Colors.black : Colors.white, // inverted text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Save"),
            ),
          ],
        ),
      ],
    );
  }
}
