import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bethany/data/api.dart';
import 'package:bethany/screens/dynamic_pages/about.dart';
import 'package:bethany/theme/provider.dart';
import 'package:bethany/widget/platform_builder.dart';

Container glowingLogo(BuildContext context) {
  final provider = Provider.of<ThemeProvider>(context);
  return Container(
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixed,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primaryFixed.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.8),
            blurRadius: 20.0 * provider.blurMultiplier,
            spreadRadius: 4.0 * provider.glowMultiplier,
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
  );
}

class AboutPage extends StatelessWidget {
  AboutPage({super.key});
  final Data data = Data();
  final List<Map<String, String>> _pages = [
    {
      "label": "Our History",
      "url": "https://bethanyinstitutions.edu.in/history/"
    },
    {
      "label": "Our Vision",
      "url": "https://bethanyinstitutions.edu.in/mission-and-vision/"
    },
    {
      "label": "Director's Message",
      "url": "https://bethanyinstitutions.edu.in/directors-message/"
    },
    {
      "label": "Principal's Message",
      "url": "https://bethanyinstitutions.edu.in/principals-message/"
    },
    {
      "label": "Vice President's Message",
      "url":
          "https://bethanyinstitutions.edu.in/message-from-vice-president-b-e-b/"
    },
    {
      "label": "Faculty and Staff",
      "url": "https://bethanyinstitutions.edu.in/faculty-and-staff/"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
        children: [
          mainSection(context),
          const SizedBox(height: 10),
          aboutTile(context, "Overview", data.description1, data.image1),
          const SizedBox(height: 10),
          aboutTile(
              context, "System of Education", data.description2, data.image2),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget mainSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
          getResponsiveSize(context, mobileSize: 10, dektopSize: 20)),
      margin: EdgeInsets.all(
          getResponsiveSize(context, mobileSize: 0, dektopSize: 20)),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surfaceContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          glowingLogo(context),
          const SizedBox(height: 15),
          GridView.builder(
              shrinkWrap: true,
              itemCount: _pages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getResponsiveCrossAxisCount(context,
                      baseColumns: 2, maxColumns: 6, tabletItemWidth: 400),
                  mainAxisExtent: 70,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                Map<String, String> page = _pages[index];
                return _buildPageTile(context, page);
              }),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildPageTile(BuildContext context, Map<String, String> page) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    About(url: page['url']!, title: page['label']!)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondaryContainer,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primaryFixed.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.7),
              blurRadius: 50.0,
              spreadRadius: 2.0,
              offset: const Offset(-2.0, 0),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          page['label']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Container aboutTile(
      BuildContext context, String title, String description, String image) {
    return Container(
      padding: EdgeInsets.all(
          getResponsiveSize(context, mobileSize: 10, dektopSize: 20)),
      margin: EdgeInsets.all(
          getResponsiveSize(context, mobileSize: 0, dektopSize: 20)),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surfaceContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (image != "")
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: getResponsiveSize(context,
                      mobileSize: 200, dektopSize: 400),
                  width: double.infinity,
                  fit: BoxFit.cover,
                )),
          const SizedBox(height: 10),
          Text(description),
        ],
      ),
    );
  }
}
