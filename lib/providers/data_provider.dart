import 'package:flutter/material.dart';
import 'package:school_app/data/api.dart';

class DataProvider extends ChangeNotifier {
  dynamic homePageData;
  DataProvider() {
    fetchHomePageData();
  }

  Future<void> fetchHomePageData() async {
    final temp = await fetchHomePage();
    homePageData = temp;
    notifyListeners();
  }

  dynamic getData() {
    return homePageData ?? [];
  }
}
