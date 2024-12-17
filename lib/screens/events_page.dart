import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconly/iconly.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:bethany/providers/data_provider.dart';
import 'package:bethany/screens/dynamic_pages/event.dart';
import 'package:bethany/widget/platform_builder.dart';
import 'package:shimmer/shimmer.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

enum EventLayout {
  list,
  cover,
  mason,
}

class _EventsPageState extends State<EventsPage> {
  dynamic events;
  EventLayout currentLayout = EventLayout.list;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final provider = Provider.of<DataProvider>(context, listen: false);
    final data = await provider.fetchEventsData();
    setState(() {
      events = data;
    });
  }

  void toggleLayout() {
    final index = EventLayout.values.indexOf(currentLayout);
    final newIndex = (index + 1) % EventLayout.values.length;
    setState(() {
      currentLayout = EventLayout.values[newIndex];
    });
  }

  Icon handleLayoutIcon() {
    if (currentLayout == EventLayout.list) {
      return const Icon(LucideIcons.alignJustify);
    } else if (currentLayout == EventLayout.cover) {
      return const Icon(LucideIcons.image);
    } else {
      return const Icon(LucideIcons.grid);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (events == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin:  EdgeInsets.symmetric(horizontal: getResponsiveSize(context, mobileSize: 10, dektopSize: 40)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Top Events",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary)),
                ),
                const SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    height: getResponsiveSize(context,
                        mobileSize: 270, dektopSize: 430),
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: [events[0], events[1], events[2]].map<Widget>((i) {
                    final random = Random().nextInt(10000);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventPage(
                                          eventLink: i['link'],
                                          eventName: i['title'],
                                          heroTag: '${i['title']}-$random',
                                          imageUrl: i['image'],
                                        )));
                          },
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Hero(
                                tag: '${i['title']}-$random',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: i['image'],
                                    height: getResponsiveSize(context,
                                        mobileSize: 150, dektopSize: 350),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            i['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            i['description'],
                            style: const TextStyle(),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12)),
            margin:  EdgeInsets.symmetric(horizontal: getResponsiveSize(context, mobileSize: 10, dektopSize: 40)),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Events",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary)),
                    IconButton(
                        onPressed: () => toggleLayout(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                        icon: handleLayoutIcon())
                  ],
                ),
                const SizedBox(height: 20),
                if (events != null)
                  if (currentLayout == EventLayout.mason) ...[
                    _buildInstaPosts(context, events)
                  ] else ...[
                    ...events.map((event) {
                      int index = events.indexOf(event);
                      if (index == events.length - 1) {
                        return const SizedBox.shrink();
                      }
                      return layoutHandler(context, event, index);
                    }).toList()
                  ]
                else
                  const Center(
                    child: SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget layoutHandler(BuildContext context, dynamic event, int index) {
    if (currentLayout == EventLayout.list) {
      return _buildEventTile(context, event, index);
    } else if (currentLayout == EventLayout.cover) {
      return _buildEventImageTile(context, event, index);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildInstaPosts(BuildContext context, dynamic instaData) {
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: getResponsiveValue(context, mobileValue: 2, desktopValue: 4),
      ),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: instaData.length,
      itemBuilder: (context, index) {
        final double extent = index % 2 == 0 ? 300.0 : 150.0;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: instaData[index]['image'],
                fit: BoxFit.cover,
                height: extent,
                width: double.infinity,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    height: 250,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    instaData[index]['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

_buildEventImageTile(BuildContext context, dynamic event, int index) {
  final random = Random().nextInt(10000);
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventPage(
                    heroTag: '${event['title']}-$random',
                    imageUrl: event['image'],
                    eventLink: event['link'],
                    eventName: event['title'],
                  )));
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
      child: Column(
        children: [
          Hero(
            tag: '${event['title']}-$random',
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: event['image'],
                  width: double.infinity,
                  height: getResponsiveSize(context, mobileSize: 150, dektopSize: 300),
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.3
                              : 0.4),
                      blurRadius: 20,
                      spreadRadius: 4.0,
                      offset: const Offset(-2.0, 0),
                    ),
                  ],
                ),
                child: Text('#${index + 1}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  event['title'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(event['description'], maxLines: 3),
        ],
      ),
    ),
  );
}

_buildEventTile(BuildContext context, dynamic event, int index) {
  final random = Random().nextInt(10000);
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventPage(
                    eventLink: event['link'],
                    eventName: event['title'],
                    heroTag: '${event['title']}-$random',
                    imageUrl: event['image'],
                  )));
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(
                      Theme.of(context).brightness == Brightness.dark
                          ? 0.3
                          : 0.4),
                  blurRadius: 20,
                  spreadRadius: 4.0,
                  offset: const Offset(-2.0, 0),
                ),
              ],
            ),
            child: Text('#${index + 1}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              event['title'],
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventPage(
                              eventLink: event['link'],
                              eventName: event['title'],
                              heroTag: '',
                              imageUrl: '',
                            )));
              },
              icon: const Icon(IconlyBold.arrow_right))
        ],
      ),
    ),
  );
}
