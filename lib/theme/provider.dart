import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:school_app/theme/themes.dart';

class ThemeProvider extends ChangeNotifier {
  bool isLightMode = true;
  ThemeData _selectedTheme;
  Color? _seedColor;

  ThemeProvider({Color? initialColor})
      : _seedColor = initialColor ?? Colors.deepPurple,
        _selectedTheme = AppTheme.darkTheme {
    _loadDynamicTheme();
  }

  ThemeData get selectedTheme => _selectedTheme;

  Future<void> _loadDynamicTheme() async {
    final corePalette = await DynamicColorPlugin.getCorePalette();
    if (corePalette != null) {
      _seedColor = Color(corePalette.primary.get(40));
    } else {
      _seedColor = Colors.green;
    }
    _updateTheme();
  }

  void toggleTheme() {
    isLightMode = !isLightMode;
    _updateTheme();
  }

  void setLightMode() {
    isLightMode = true;
    _updateTheme();
  }

  void setDarkMode() {
    isLightMode = false;
    _updateTheme();
  }

  void setCustomSeedColor(Color newColor) {
    _seedColor = newColor;
    _updateTheme();
  }

  void _updateTheme() {
    _selectedTheme = isLightMode
        ? AppTheme.lightTheme.copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: _seedColor!,
              brightness: Brightness.light,
            ),
          )
        : AppTheme.darkTheme.copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: _seedColor!,
              brightness: Brightness.dark,
            ),
          );

    notifyListeners();
  }
}
