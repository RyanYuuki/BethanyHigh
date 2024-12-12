import 'package:flutter/material.dart';
import 'package:bethany/data/api.dart';

class DataProvider extends ChangeNotifier {
  dynamic homePageData;
  dynamic eventsData;
  DataProvider() {
    fetchHomePageData();
  }

  Future<dynamic> fetchHomePageData() async {
    if (homePageData == null) {
      final temp = await fetchHomePage();
      homePageData = temp;
      return homePageData;
    } else {
      return homePageData;
    }
  }

  Future<dynamic> fetchEventsData() async {
    if (eventsData == null) {
      final temp = await fetchEvents();
      eventsData = temp;
      return eventsData;
    } else {
      return eventsData;
    }
  }
}
