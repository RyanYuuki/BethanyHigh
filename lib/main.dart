import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:school_app/providers/data_provider.dart';
import 'package:school_app/screens/about_page.dart';
import 'package:school_app/screens/events_page.dart';
import 'package:school_app/screens/notices_page.dart';
import 'package:school_app/theme/provider.dart';
import 'package:school_app/widget/drawer.dart';
import 'screens/home_page.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(initialColor: Colors.green),
        ),
        ChangeNotifierProvider(create: (_) => DataProvider())
      ],
      child: const MainApp(),
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const EventsPage(),
    const NoticesPage(),
    const AboutPage(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: themeProvider.selectedTheme,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(
          currentIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
        body: Container(
          color: themeProvider.selectedTheme.colorScheme.surface,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider
                              .selectedTheme.colorScheme.surfaceContainer),
                      icon: const Icon(HugeIcons.strokeRoundedMenu01),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Good Morning,"),
                        Text("Welcome to Bethany High",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider
                              .selectedTheme.colorScheme.surfaceContainer),
                      icon: Icon(
                        themeProvider.isLightMode
                            ? HugeIcons.strokeRoundedSun03
                            : HugeIcons.strokeRoundedMoon01,
                      ),
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
