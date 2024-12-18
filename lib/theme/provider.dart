import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hive/hive.dart';
import 'package:bethany/data/constants.dart';
import 'package:bethany/theme/themes.dart';

class ThemeProvider extends ChangeNotifier {
  bool isLightMode;
  bool isOled;
  late ThemeData _selectedTheme;
  late String currentThemeMode;
  Color _seedColor;
  late double glowMultiplier;
  late double radiusMultiplier;
  late double blurMultiplier;
  late int selectedVariantIndex;

  List<String> availThemeModes = ["default", "material", "custom"];

  ThemeProvider()
      : _seedColor = Colors.green,
        isLightMode =
            Hive.box("themeData").get("isLightMode", defaultValue: true),
        isOled = Hive.box("themeData").get("isOled", defaultValue: false),
        glowMultiplier =
            Hive.box("themeData").get("glowMultiplier", defaultValue: 1.0),
        radiusMultiplier =
            Hive.box("themeData").get("radiusMultiplier", defaultValue: 1.0),
        blurMultiplier =
            Hive.box("themeData").get("blurMultiplier", defaultValue: 1.0),
        selectedVariantIndex =
            Hive.box("themeData").get("selectedVariantIndex", defaultValue: 0),
        currentThemeMode =
            Hive.box("themeData").get("themeMode", defaultValue: "default") {
    _determineSeedColor();
    _updateTheme();
  }

  ThemeData get selectedTheme => _selectedTheme;

  void _determineSeedColor() {
    if (currentThemeMode == "default") {
      _seedColor = Colors.green;
    } else if (currentThemeMode == "material") {
      loadDynamicTheme();
    } else {
      final box = Hive.box("themeData");
      int colorIndex = box.get("customColorIndex", defaultValue: 0);
      _seedColor = colorList[colorIndex];
    }
  }

  Future<void> loadDynamicTheme() async {
    currentThemeMode = "material";
    Hive.box("themeData").put("themeMode", "material");
    final corePalette = await DynamicColorPlugin.getCorePalette();
    _seedColor =
        corePalette != null ? Color(corePalette.primary.get(40)) : Colors.green;
    _updateTheme();
  }

  void updateGlowMultiplier(double value) {
    Hive.box("themeData").put("glowMultiplier", value);
    glowMultiplier = value;
    notifyListeners();
  }

  void updateRadiusMultiplier(double value) {
    Hive.box("themeData").put("radiusMultiplier", value);
    radiusMultiplier = value;
    notifyListeners();
  }

  void updateBlurMultiplier(double value) {
    Hive.box("themeData").put("blurMultiplier", value);
    blurMultiplier = value;
    notifyListeners();
  }

  void updateSchemeVariant(int index) {
    Hive.box("themeData").put("selectedVariantIndex", index);
    selectedVariantIndex = index;
    _updateTheme();
  }

  void toggleTheme() {
    isLightMode = !isLightMode;
    Hive.box("themeData").put("isLightMode", isLightMode);
    _updateTheme();
  }

  void setLightMode() {
    isLightMode = true;
    Hive.box("themeData").put("isLightMode", true);
    _updateTheme();
  }

  void setDarkMode() {
    isLightMode = false;
    Hive.box("themeData").put("isLightMode", false);
    _updateTheme();
  }

  void setDefaultTheme() {
    currentThemeMode = "default";
    Hive.box("themeData").put("themeMode", "default");
    _seedColor = Colors.green;
    _updateTheme();
  }

  void setCustomSeedColor(int index) {
    currentThemeMode = "custom";
    Hive.box("themeData")
      ..put("themeMode", "custom")
      ..put("customColorIndex", index);
    _seedColor = colorList[index];
    _updateTheme();
  }

  void toggleOled(bool value) {
    isOled = value;
    Hive.box("themeData").put("isOled", value);
    _updateTheme();
  }

  void clearCache() {
    final box = Hive.box("themeData");
    box.clear();
    isLightMode = true;
    isOled = false;
    glowMultiplier = 1.0;
    radiusMultiplier = 1.0;
    blurMultiplier = 1.0;
    selectedVariantIndex = 0;
    currentThemeMode = "default";
    _seedColor = Colors.green;

    _updateTheme();
    notifyListeners();
  }

  void _updateTheme() {
    _selectedTheme = isLightMode
        ? AppTheme.lightTheme.copyWith(
            colorScheme: ColorScheme.fromSeed(
                seedColor: _seedColor,
                brightness: Brightness.light,
                surface: isOled ? Colors.white : null,
                dynamicSchemeVariant:
                    dynamicSchemeVariantList[selectedVariantIndex]),
          )
        : AppTheme.darkTheme.copyWith(
            colorScheme: ColorScheme.fromSeed(
                seedColor: _seedColor,
                brightness: Brightness.dark,
                surface: isOled ? Colors.black : null,
                dynamicSchemeVariant:
                    dynamicSchemeVariantList[selectedVariantIndex]),
          );
    notifyListeners();
  }
}
