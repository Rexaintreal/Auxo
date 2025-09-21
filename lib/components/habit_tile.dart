import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Slightly elevated colors for better contrast
    final Color tileColor = isDark
        ? const Color(0xFF1E1E1E) // deep grey but not pure black
        : const Color(0xFFF9F9FB); // soft warm white

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // Settings button (left side)
            SlidableAction(
              onPressed: settingsTapped,
              backgroundColor: isDark ? Colors.black : Colors.white,
              foregroundColor: isDark ? Colors.white : Colors.black,
              icon: Icons.settings,
              label: 'Edit',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            // Delete button (right side)
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: isDark ? Colors.black : Colors.white,
              foregroundColor: Colors.redAccent,
              icon: Icons.delete_outline,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ],
        ),

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    // ignore: deprecated_member_use
                    ? Colors.black.withOpacity(0.3)
                    // ignore: deprecated_member_use
                    : Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Checkbox(
                value: habitCompleted,
                onChanged: onChanged,
                activeColor: const Color(0xFF34C759), // keep the green tick
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  habitName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: habitCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: habitCompleted
                        ? (isDark ? Colors.grey[500] : Colors.grey[600])
                        : scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
