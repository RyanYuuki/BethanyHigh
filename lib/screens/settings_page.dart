import 'package:bethany/theme/provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:bethany/screens/settings/settings_about.dart';
import 'package:bethany/screens/settings/settings_theme.dart';
import 'package:bethany/screens/settings/settings_ui.dart';
import 'package:bethany/widget/custom_tile.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool test = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 50.0, 25.0, 20.0),
          child: SingleChildScrollView(
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 30),
                CustomTile(
                    icon: HugeIcons.strokeRoundedPaintBoard,
                    title: "UI",
                    description: "Play around with App theme",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsUi()));
                    }),
                CustomTile(
                    icon: HugeIcons.strokeRoundedPaintBrush01,
                    title: "Theme",
                    description: "Play around with App theme",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsTheme()));
                    }),
                CustomTile(
                    icon: Iconsax.trash,
                    title: "Clear Cache",
                    description: "Clear all the settings.",
                    onTap: () {
                      showClearCacheDialog(context);
                    }),
                const SizedBox(height: 10),
                CustomTile(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  title: "About",
                  description: "About the App",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsAbout()));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

Future<void> showClearCacheDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: const Text('Are you sure you want to clear the cache?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Theme.of(context).colorScheme.primaryFixed),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).clearCache();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
