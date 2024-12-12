import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bethany/theme/provider.dart';
import 'package:bethany/widget/slider_semantics.dart';

class CustomSliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double sliderValue;
  final double max;
  final Function(double value) onChanged;

  const CustomSliderTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.sliderValue,
    required this.onChanged,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, widget) {
      final glowMultiplier = provider.glowMultiplier;
      final blurMultiplier = provider.blurMultiplier;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 30, color: Theme.of(context).colorScheme.primary),
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
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(sliderValue.toStringAsPrecision(2)),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? 0.3
                                    : 0.6),
                            blurRadius: 58.0 * blurMultiplier,
                            spreadRadius: 2.0 * glowMultiplier,
                            offset: const Offset(-2.0, 0),
                          ),
                        ],
                      ),
                      child: CustomSlider(
                        value: double.parse(sliderValue.toStringAsFixed(2)),
                        onChanged: onChanged,
                        max: max,
                        min: 0.0,
                        divisions: (max * 10).toInt(),
                        customValueIndicatorSize: RoundedSliderValueIndicator(
                          Theme.of(context).colorScheme,
                          width: 40,
                          height: 40,
                        ),
                      )),
                ),
                const SizedBox(width: 10),
                Text(max.toStringAsPrecision(2)),
              ],
            )
          ],
        ),
      );
    });
  }
}
