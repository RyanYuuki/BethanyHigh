import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:school_app/data/scrapper.dart';
import 'package:shimmer/shimmer.dart';

class EventPage extends StatefulWidget {
  final String eventLink;
  final String eventName;
  const EventPage(
      {super.key, required this.eventLink, required this.eventName});

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
    final tempData = await NeerajSchoolScrapper().fetchEvent(widget.eventLink);
    setState(() {
      data = tempData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading Event Details...',
                style: Theme.of(context).textTheme.titleMedium,
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              icon: Icon(
                IconlyBold.arrow_left,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              widget.eventName,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            floating: true,
            snap: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: CarouselView(
                    itemExtent: MediaQuery.of(context).size.width * 0.90,
                    shrinkExtent: 200,
                    padding: const EdgeInsets.all(10.0),
                    children: List.generate(
                      data['images'].length,
                      (index) => ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: CachedNetworkImage(
                          imageUrl: data['images'][index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[900]!,
                            highlightColor: Colors.grey[700]!,
                            child: Container(
                              color: Colors.grey[400],
                              height: 250,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      data['body'][index],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  );
                },
                childCount: data['body'].length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
