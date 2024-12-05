import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:school_app/data/scrapper.dart';
import 'package:school_app/screens/dynamic_pages/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  dynamic events;
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final resp = await NeerajSchoolScrapper().fetchEvents();
    setState(() {
      events = resp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Events",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 20),
                if (events != null)
                  ...events.map((event) {
                    int index = events.indexOf(event);
                    if (index == events.length - 1) return const SizedBox.shrink();
                    return _buildEventTile(context, event, index);
                  }).toList()
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

  _buildEventTile(BuildContext context, dynamic event, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventPage(
                      eventLink: event['link'],
                      eventName: event['title'],
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
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary.withOpacity(
                        Theme.of(context).brightness == Brightness.dark
                            ? 0.3
                            : 0.4),
                    blurRadius: 10.0,
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
            const SizedBox(width: 15),
            Text(event['title']),
            const Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(
                                eventLink: event['link'],
                                eventName: event['title'],
                              )));
                },
                icon: const Icon(IconlyBold.arrow_right))
          ],
        ),
      ),
    );
  }
}
