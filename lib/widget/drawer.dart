import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:bethany/screens/settings_page.dart';
import 'package:bethany/theme/provider.dart';
import 'package:bethany/widget/platform_builder.dart';

class CustomDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  double? glowMultiplier;
  double? blurMultiplier;
  CustomDrawer({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    glowMultiplier = provider.glowMultiplier;
    blurMultiplier = provider.blurMultiplier;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      width: getResponsiveSize(context,
          mobileSize: MediaQuery.of(context).size.width * 0.5,
          dektopSize: MediaQuery.of(context).size.width * 0.2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 15),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryFixed,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryFixed
                          .withOpacity(
                              Theme.of(context).brightness == Brightness.dark
                                  ? 0.3
                                  : 0.8),
                      blurRadius: 20 * blurMultiplier!,
                      spreadRadius: 4.0 * glowMultiplier!,
                      offset: const Offset(-2.0, 0),
                    ),
                  ]),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        height: 60,
                        imageUrl:
                            'https://bethanyinstitutions.edu.in///wp-content/uploads/2023/10/Bethany-Approved-Logo-07-scaled.webp',
                      )),
                  // const Spacer()
                ],
              ),
            ),
            Divider(
              height: 30,
              indent: 5,
              endIndent: 5,
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            _buildDrawerItem(
                IconlyLight.home, 'Home', 0, context, IconlyBold.home),
            _buildDrawerItem(IconlyLight.calendar, 'Events', 1, context,
                IconlyBold.calendar),
            _buildDrawerItem(
                IconlyLight.call, 'Contact', 2, context, IconlyBold.call),
            _buildDrawerItem(IconlyLight.info_circle, 'About', 3, context,
                IconlyBold.info_circle),
            const Spacer(),
            Divider(
              height: 30,
              indent: 5,
              endIndent: 5,
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            _buildDrawerItem(IconlyLight.setting, 'Settings', 4, context,
                IconlyBold.setting),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index,
      BuildContext context, IconData selectedIcon) {
    final isSelected = currentIndex == index;
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected || title == "Settings"
              ? [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryFixed
                        .withOpacity(
                            Theme.of(context).brightness == Brightness.dark
                                ? 0.3
                                : 0.8),
                    blurRadius: 20 * blurMultiplier!,
                    spreadRadius: 4.0 * glowMultiplier!,
                    offset: const Offset(-2.0, 0),
                  ),
                ]
              : [],
          color: isSelected || title == "Settings"
              ? title == "Settings"
                  ? Theme.of(context).colorScheme.primaryFixed
                  : Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer),
      child: ListTile(
        leading: Icon(isSelected ? selectedIcon : icon,
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : title == "Settings"
                    ? Theme.of(context).colorScheme.onPrimaryFixed
                    : null),
        title: Text(title,
            style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.surface
                    : title == "Settings"
                        ? Theme.of(context).colorScheme.onPrimaryFixed
                        : null,
                fontWeight: FontWeight.bold)),
        selected: isSelected,
        onTap: () {
          if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          } else {
            onItemSelected(index);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
