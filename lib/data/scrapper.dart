import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NeerajSchoolScrapper extends ChangeNotifier {
  String schoolName = "Neeraj Modi";
  String baseUrl = 'https://www.nmsindia.org';
  Dio dio = Dio();

  Future<dynamic> fetchHomePage() async {
    var resp = await dio.get(
        'https://storage.elfsight.com/api/v2/data/19ec5d41f3b6cf80f70bf4b54fdd9c55');

    if (resp.statusCode == 200) {
      var data = resp.data;
      var bigCarouselElements = data['data']['posts'];
      List<Map<String, String>> bigCarousel = [];
      for (var i in bigCarouselElements) {
        bigCarousel.add({
          "title": i['caption'],
          "image": i['images']['thumbnail']['url'],
          "link": i['link']
        });
      }
      List<String?> smallCarousel = [];
      var smallCarouselElements =
          document.querySelectorAll('.es-post-media-image');
      for (var el in smallCarouselElements) {
        smallCarousel.add(el.attributes['src']);
      }
    }
  }

  Future<dynamic> fetchAboutPage() async {}
}
