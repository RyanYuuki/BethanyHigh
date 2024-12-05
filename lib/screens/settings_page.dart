import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:school_app/widget/custom_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
          child: Column(
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
                  const Text("Settings",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              const SizedBox(height: 30),
              CustomTile(
                  icon: HugeIcons.strokeRoundedPaintBrush01,
                  title: "Theme",
                  description: "Play around with App theme",
                  onTap: () {}),
              const SizedBox(height: 10),
              CustomTile(
                icon: HugeIcons.strokeRoundedInformationCircle,
                title: "About",
                description: "About the App",
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
