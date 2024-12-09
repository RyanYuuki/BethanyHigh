import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/data/api.dart';
import 'package:school_app/screens/dynamic_pages/about.dart';
import 'package:school_app/theme/provider.dart';
import 'package:shimmer/shimmer.dart';

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
      padding: const EdgeInsets.all(10),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
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
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withOpacity(Theme.of(context).brightness == Brightness.dark
                      ? 0.3
                      : 0.7),
              blurRadius: 10.0,
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
      padding: const EdgeInsets.all(10),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (image != "")
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )),
          const SizedBox(height: 10),
          Text(description),
        ],
      ),
    );
  }

  Container glowingLogo(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryFixed,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primaryFixed.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.8),
              blurRadius: 10.0,
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

  Column _buildInfoSegment(
      String heading, String imgUrl, String description, BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
            filterQuality: FilterQuality.high,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surface,
              highlightColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                height: 250,
                width: double.infinity,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(heading,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
