import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bethany/data/api.dart';
import 'package:bethany/theme/provider.dart';
import 'package:bethany/widget/platform_builder.dart';

class About extends StatefulWidget {
  final String url;
  final String title;
  const About({super.key, required this.url, required this.title});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  Future<dynamic>? data;

  @override
  void initState() {
    super.initState();
    data = fetchAboutDataByUrl(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Scaffold(
            body: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveSize(context,
                      mobileSize: 10, dektopSize: 30),
                  vertical: 40),
              children: [
                Row(
                  children: [
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainer,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(width: 10),
                    Text(widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 30),
                _buildBody(context, snapshot.data!),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: const Center(
            child: Text("No data available"),
          ),
        );
      },
    );
  }

  Container _buildBody(BuildContext context, Map<String, dynamic> data) {
    final provider = Provider.of<ThemeProvider>(context);
    final radiusMultiplier = provider.radiusMultiplier;
    final glowMultiplier = provider.glowMultiplier;
    final blurMultiplier = provider.blurMultiplier;
    return Container(
      padding: EdgeInsets.all(
          getResponsiveSize(context, mobileSize: 10, dektopSize: 20)),
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
        color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(140),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: data['image'] ?? '',
            height:
                getResponsiveSize(context, mobileSize: 250, dektopSize: 400),
            width: double.infinity,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(height: 10),
        ...data['body'].map<Widget>((content) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8 * radiusMultiplier),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryFixedDim
                      .withOpacity(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.3
                              : 1),
                  blurRadius: 20 * blurMultiplier,
                  spreadRadius: 2.0 * glowMultiplier,
                  offset: const Offset(-2.0, 0),
                ),
              ],
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              ),
            ),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          );
        }).toList(),
      ]),
    );
  }
}
