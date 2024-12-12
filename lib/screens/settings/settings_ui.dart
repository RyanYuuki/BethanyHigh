import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:bethany/theme/provider.dart';
import 'package:bethany/widget/custom_slider_tile.dart';

class SettingsUi extends StatefulWidget {
  const SettingsUi({super.key});

  @override
  State<SettingsUi> createState() => _SettingsUiState();
}

class _SettingsUiState extends State<SettingsUi> {
  late double glowMultiplier;
  late double radiusMultiplier;
  late double blurMultiplier;

  @override
  void initState() {
    super.initState();
    _initializeDbVars();
  }

  void _initializeDbVars() {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    glowMultiplier = provider.glowMultiplier;
    radiusMultiplier = provider.radiusMultiplier;
    blurMultiplier = provider.blurMultiplier;
  }

  void handleGlowMultiplier(double value) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    setState(() {
      glowMultiplier = value;
    });
    provider.updateGlowMultiplier(value);
  }

  void handleRadiusMultiplier(double value) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    setState(() {
      radiusMultiplier = value;
    });
    provider.updateRadiusMultiplier(value);
  }

  void handleBlurMultiplier(double value) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    setState(() {
      blurMultiplier = value;
    });
    provider.updateBlurMultiplier(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  const SizedBox(width: 10),
                  const Text("UI",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              const SizedBox(height: 30),
              Text("Common",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10),
              CustomSliderTile(
                icon: HugeIcons.strokeRoundedLighthouse,
                title: "Glow Multiplier",
                description: "Adjust the glow of all the elements",
                sliderValue: glowMultiplier,
                onChanged: handleGlowMultiplier,
                max: 5.0,
              ),
              const SizedBox(height: 20),
              CustomSliderTile(
                icon: HugeIcons.strokeRoundedRadius,
                title: "Radius Multiplier",
                description: "Adjust the radius of all the elements",
                sliderValue: radiusMultiplier,
                onChanged: handleRadiusMultiplier,
                max: 3.0,
              ),
              const SizedBox(height: 20),
              CustomSliderTile(
                icon: HugeIcons.strokeRoundedRadius,
                title: "Blur Multiplier",
                description: "Adjust the Glow Blur of all the elements",
                sliderValue: blurMultiplier,
                onChanged: handleBlurMultiplier,
                max: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
