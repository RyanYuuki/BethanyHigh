import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool switchValue;
  final Function(bool value) onChanged;

  const CustomSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.switchValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
              decoration: BoxDecoration(
                boxShadow: switchValue
                    ? [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? 0.3
                                  : 0.6),
                          blurRadius: 58.0,
                          spreadRadius: 10.0,
                          offset: const Offset(-2.0, 0),
                        ),
                      ]
                    : [],
              ),
              child: Switch(value: switchValue, onChanged: onChanged))
        ],
      ),
    );
  }
}
