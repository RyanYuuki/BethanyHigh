import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_app/data/api.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: data['image'] ?? '',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(height: 10),
        ...data['body']
            .map<Widget>((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    e?.toString() ?? 'No description available.',
                  ),
                ))
            .toList()
      ]),
    );
  }
}
