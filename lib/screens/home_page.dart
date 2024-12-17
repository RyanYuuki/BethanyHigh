import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bethany/providers/data_provider.dart';
import 'package:bethany/theme/provider.dart';
import 'package:bethany/widget/platform_builder.dart';
import 'package:shimmer/shimmer.dart';

String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return "Good Morning!";
  } else if (hour >= 12 && hour < 17) {
    return "Good Afternoon!";
  } else if (hour >= 17 && hour < 21) {
    return "Good Evening!";
  } else {
    return "Good Night!";
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic data;
  late double radiusMultiplier;
  late double glowMultiplier;
  late double blurMultiplier;

  List<Map<String, String>> figures = [
    {"title": "Years Since Inception", "progress": "60"},
    {"title": "Total Graduates", "progress": "10000"},
    {
      "title": "Faculty",
      "progress": "318",
    },
    {"title": "Scholarship Awarded", "progress": "713"},
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final tempData = await Provider.of<DataProvider>(context, listen: false)
        .fetchHomePageData();
    if (tempData != null) {
      setState(() {
        data = tempData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const SizedBox(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        final campusImages = data?['campusImages'];
        final smallData = data?['smallData'];
        final topStudents = data?['topStudents'];
        final upcomingEvents = data?['upcomingEvents'];
        final latestEvents = data?['events'];
        final ourPolicies = data?['policies'];
        final departmentImages = data['departmentImages'];
        final provider = Provider.of<ThemeProvider>(context);
        radiusMultiplier = provider.radiusMultiplier;
        glowMultiplier = provider.glowMultiplier;
        blurMultiplier = provider.blurMultiplier;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: ListView(
            padding: getResponsiveValue(context,
                mobileValue: const EdgeInsets.only(bottom: 100),
                desktopValue: const EdgeInsets.symmetric(horizontal: 30)),
            shrinkWrap: true,
            children: [
              PlatformBuilder(
                androidBuilder: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text("Discover our Departments",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12 * radiusMultiplier),
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.surface,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: getResponsiveSize(context,
                                  mobileSize: 140, dektopSize: 300),
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
                            items: departmentImages.map<Widget>((i) {
                              return Container(
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          12 * radiusMultiplier)),
                                  child: CachedNetworkImage(
                                    imageUrl: i,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ));
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text("Bethany Institutions",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 5),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                                "A community fostering greatness through unity. Explore our top ICSE schools and citywide branches.",
                                style: TextStyle()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                desktopBuilder: const SizedBox.shrink(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Discover our Campus",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              SizedBox(
                height: getResponsiveSize(context,
                    mobileSize: 270, dektopSize: 400),
                child: CarouselView(
                  itemSnapping: true,
                  itemExtent: MediaQuery.of(context).size.width,
                  shrinkExtent: 200,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12 * radiusMultiplier)),
                  padding: const EdgeInsets.all(10.0),
                  children: List.generate(
                    campusImages.length,
                    (index) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.surface,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: campusImages[index]['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: getResponsiveSize(context,
                                mobileSize: 200, dektopSize: 330),
                            filterQuality: FilterQuality.high,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Theme.of(context).colorScheme.surface,
                              highlightColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                height: 250,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            campusImages[index]['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Facts & Figures",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getResponsiveCrossAxisCount(context,
                      baseColumns: 2,
                      maxColumns: 4,
                      mobileBreakpoint: 800,
                      tabletBreakpoint: 1200),
                  mainAxisExtent: 130,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: figures.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12 * radiusMultiplier),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.surface,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                BorderRadius.circular(12 * radiusMultiplier),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 0.3
                                        : 0.7),
                                blurRadius: 10.0 * blurMultiplier,
                                spreadRadius: 2.0 * glowMultiplier,
                                offset: const Offset(-2.0, 0),
                              ),
                            ],
                          ),
                          child: Text(
                            '+${figures[index]['progress']}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          figures[index]['title']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Why Choose Us?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getResponsiveCrossAxisCount(context,
                      baseColumns: 1,
                      maxColumns: 3,
                      tabletItemWidth: 400,
                      mobileItemWidth: 400),
                  mainAxisExtent: 200,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: smallData.length,
                itemBuilder: (context, index) {
                  final itemData = smallData[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12 * radiusMultiplier),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12 * radiusMultiplier),
                          child: CachedNetworkImage(
                            imageUrl: itemData['image'],
                            height: 150,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                itemData['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                itemData['description'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Our Policies",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getResponsiveCrossAxisCount(context,
                        baseColumns: 1,
                        maxColumns: 4,
                        mobileItemWidth: 300,
                        tabletItemWidth: 400,
                        desktopItemWidth: 350),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 270),
                itemCount: ourPolicies.length,
                itemBuilder: (context, index) {
                  final itemData = ourPolicies[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12 * radiusMultiplier),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(8 * radiusMultiplier),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? 0.3
                                                : 0.7),
                                    blurRadius: 10.0 * blurMultiplier,
                                    spreadRadius: 4.0 * glowMultiplier,
                                    offset: const Offset(-2.0, 0),
                                  ),
                                ],
                                color: Theme.of(context).colorScheme.primary),
                            child: CachedNetworkImage(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).colorScheme.surface,
                                imageUrl: itemData['image'])),
                        const SizedBox(height: 8),
                        Text(
                          itemData['title']!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          itemData['description']!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 10,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Upcoming Events",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getResponsiveCrossAxisCount(context,
                      baseColumns: 2, maxColumns: 4, tabletItemWidth: 300),
                  mainAxisExtent: 138,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  final itemData = upcomingEvents[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12 * radiusMultiplier),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(8 * radiusMultiplier),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? 0.3
                                              : 0.7),
                                  blurRadius: 10.0 * blurMultiplier,
                                  spreadRadius: 4.0 * glowMultiplier,
                                  offset: const Offset(-2.0, 0),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.primary),
                          child: Text(itemData['date'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                              )),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          itemData['title']!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Latest Posts",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getResponsiveValue(context,
                      mobileValue: 1, desktopValue: 2),
                  mainAxisExtent: getResponsiveSize(context,
                      mobileSize: 330, dektopSize: 370),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  final itemData = latestEvents[index == 1 ? index + 1 : index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12 * radiusMultiplier),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8 * radiusMultiplier),
                          child: CachedNetworkImage(
                            imageUrl: itemData['image'],
                            height: getResponsiveSize(context,
                                mobileSize: 150, dektopSize: 200),
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                itemData['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                itemData['description'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        8 * radiusMultiplier),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? 0.3
                                                    : 0.7),
                                        blurRadius: 10.0 * blurMultiplier,
                                        spreadRadius: 4.0 * glowMultiplier,
                                        offset: const Offset(-2.0, 0),
                                      ),
                                    ],
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                child: Text(itemData['date'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Top Students",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getResponsiveCrossAxisCount(context,
                      baseColumns: 1,
                      maxColumns: 4,
                      mobileItemWidth: 300,
                      tabletItemWidth: 500),
                  mainAxisExtent: 200,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: topStudents.length,
                itemBuilder: (context, index) {
                  final itemData = topStudents[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12 * radiusMultiplier),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: itemData['image'],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                itemData['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                itemData['description'][0],
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
