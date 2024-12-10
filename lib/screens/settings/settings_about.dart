import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;
import 'package:school_app/widget/about_page_deps.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlHelper(String link) async {
  final url = Uri.parse(link);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.inAppBrowserView);
  } else {
    throw 'Could not launch $link';
  }
}

class SettingsAbout extends StatelessWidget {
  const SettingsAbout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Column(
              children: [
                const HeaderSection(),
                const SizedBox(height: 16),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              FutureBuilder<PackageInfo>(
                                future: PackageInfo.fromPlatform(),
                                builder: (context, snapshot) {
                                  final version = snapshot.hasData
                                      ? snapshot.data!.version
                                      : '';
                                  return ProfileInfo(
                                    username: "Bethany",
                                    version: "v$version",
                                    subtitle: "",
                                  );
                                },
                              ),
                              InfoCard(
                                onTap: () async {
                                  await launchUrlHelper(
                                      'https://github.com/RyanYuuki');
                                },
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://avatars.githubusercontent.com/u/108048963?s=400&u=7f67531c27c5ebbbcde943f9576a0bfdb98909c8&v=4'),
                                ),
                                title: "Developer",
                                subtitle: "Rehan",
                                trailing: IconButton(
                                  onPressed: () async {
                                    await launchUrlHelper(
                                        'https://github.com/RyanYuuki');
                                  },
                                  icon: const Icon(Iconsax.code5),
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: -5,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: theme.colorScheme.surfaceContainer),
                            child: Image.network(
                              'https://yt3.googleusercontent.com/ytc/AIdro_kbUn0KExd-k_DVX7vEdro7maxOZEnODNhM_KFE2q_PTA=s900-c-k-c0x00ffffff-no-rj',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomSection(
                    icon: Iconsax.code_circle,
                    title: "Development",
                    subtitle: "Explore the project and contribute",
                    items: [
                      CustomListTile(
                        onTap: () async {
                          await launchUrlHelper(
                              'https://github.com/RyanYuuki/Bethany');
                        },
                        leading: const Icon(HugeIcons.strokeRoundedGithub),
                        title: "GitHub",
                        subtitle: 'View Source code on github.',
                      ),
                      CustomListTile(
                        onTap: () async {
                          await launchUrlHelper(
                              'https://github.com/RyanYuuki/Bethany/issues');
                        },
                        leading: const Icon(Icons.bug_report),
                        title: "Features/Issues",
                        subtitle:
                            'if you have an issue or any suggestion please make an issue at github.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12)),
                  child: CustomSection(
                    icon: Iconsax.link_circle,
                    title: "Social",
                    subtitle:
                        "Join us for dropping feedback or feature requests",
                    items: [
                      CustomListTile(
                        onTap: () async {
                          await launchUrlHelper('https://t.me/RyanYuuki');
                        },
                        leading: const Icon(HugeIcons.strokeRoundedTelegram),
                        title: "Telegram",
                      ),
                      CustomListTile(
                        onTap: () async {
                          await launchUrlHelper(
                              'https://instagram.com/_ryan.in8k');
                        },
                        leading: const Icon(HugeIcons.strokeRoundedInstagram),
                        title: "Instagram",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
