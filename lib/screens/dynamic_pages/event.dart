import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/data/api.dart';
import 'package:school_app/theme/provider.dart';
import 'package:shimmer/shimmer.dart';

class EventPage extends StatefulWidget {
  final String eventLink;
  final String eventName;
  final String heroTag;
  final String imageUrl;
  const EventPage(
      {super.key,
      required this.eventLink,
      required this.eventName,
      required this.heroTag,
      required this.imageUrl});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  dynamic data;

  @override
  void initState() {
    super.initState();
    fetchEvent();
  }

  Future<void> fetchEvent() async {
    final tempData = await fetchEventData(widget.eventLink);
    setState(() {
      data = tempData;
    });
  }

  String stripHtmlTags(String htmlString) {
    final RegExp htmlTagRegExp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(htmlTagRegExp, '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final radiusMultiplier = provider.radiusMultiplier;
    final glowMultiplier = provider.glowMultiplier;
    final blurMultiplier = provider.blurMultiplier;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
              Expanded(
                child: Text(widget.eventName,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
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
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withAlpha(140),
            ),
            child: Column(
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12 * radiusMultiplier),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                      filterQuality: FilterQuality.high,
                      errorWidget: (context, url, error) {
                        return CachedNetworkImage(
                          imageUrl: data['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                          filterQuality: FilterQuality.high,
                        );
                      },
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Theme.of(context).colorScheme.surface,
                        highlightColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        child: Container(
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          height: 250,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
                if (data != null) ...[
                  ...data['body'].map<Widget>((content) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryFixedDim
                                .withOpacity(Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? 0.3
                                    : 1),
                            blurRadius: 10.0 * blurMultiplier,
                            spreadRadius: 2.0 * glowMultiplier,
                            offset: const Offset(-2.0, 0),
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        stripHtmlTags(content),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    );
                  }).toList(),
                ] else ...[
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: const Center(child: CircularProgressIndicator()))
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
