import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';

Future<dynamic> fetchHomePage() async {
  final dio = Dio();
  const url = 'https://bethanyinstitutions.edu.in/';
  try {
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      var document = parse(response.data);
      dynamic data;
      var selector =
          document.querySelectorAll('.et_pb_column.et_pb_column_1_3');
      var smallData = [];
      for (var i in selector) {
        var imageUrl =
            i.querySelector('.et_pb_image_wrap img')?.attributes['data-src'];
        var heading = i.querySelector('.et_pb_text_inner h3')?.text;
        var description = i.querySelector('.et_pb_text_inner p')?.text;
        if (imageUrl != null && heading != null && description != null) {
          smallData.add({
            "title": heading,
            "description": description,
            "image": imageUrl
          });
        }
      }

      var postEls = document.querySelectorAll('.dipi-blog-post');
      var posts = [];
      for (var post in postEls) {
        var titleElement = post.querySelector('.dipi-entry-title > a');
        var title = titleElement?.text.trim() ?? 'No Title';
        var postLink = titleElement?.attributes['href'] ?? '';

        var imageElement = post.querySelector('.wp-post-image');
        var imageUrl = imageElement?.attributes['data-src'] ??
            imageElement?.attributes['src'] ??
            '';

        var authorElement = post.querySelector('.author.vcard > a');
        var author = authorElement?.text.trim() ?? 'No Author';

        var month = post.querySelector('.dipi-month')?.text.trim() ?? '';
        var day = post.querySelector('.dipi-day')?.text.trim() ?? '';
        var year = post.querySelector('.dipi-year')?.text.trim() ?? '';
        var postDate = '$month $day, $year';

        var excerptElement = post.querySelector('.dipi-post-text');
        var excerpt = excerptElement?.text.trim() ?? 'No Description';

        posts.add({
          "link": postLink,
          "title": title,
          "image": imageUrl,
          "author": author,
          "date": postDate,
          "description": excerpt
        });
      }

      var carouselItemEls = document.querySelectorAll('.dipi_carousel_child');
      var carouselItems = [];
      for (var item in carouselItemEls) {
        var imgTag = item.querySelector('img');
        String? imgUrl = imgTag?.attributes['data-src'];
        var titleTag = item.querySelector('.dipi-carousel-item-title');
        String? title = titleTag?.text.trim();
        var descDiv = item.querySelector('.dipi-carousel-item-desc');
        List<String> descriptions =
            descDiv?.querySelectorAll('p').map((p) => p.text.trim()).toList() ??
                [];
        carouselItems.add(
            {"title": title, "image": imgUrl, "description": descriptions});
      }

      var items = document.querySelectorAll('.n2-thumbnail-dot');
      var schoolData = [];
      for (var item in items) {
        var imgTag = item.querySelector('source');
        String? imgUrl = imgTag?.attributes['srcset'];

        if (imgUrl == null) {
          imgTag = item.querySelector('img');
          imgUrl = imgTag?.attributes['src'];
        }

        var titleTag = item
            .querySelector('.n2-font-1dea991243865176e4bd142c7ff78c4a-simple');
        String? title = titleTag?.text.trim().replaceAll(" >", "");
        schoolData.add({"title": title, "image": 'https:$imgUrl'});
      }

      var eventRows = document.querySelectorAll(
          '.tribe-common-g-row.tribe-events-widget-events-list__event-row');
      var eventRowsData = [];
      for (var eventRow in eventRows) {
        var dateTag = eventRow
            .querySelector('.tribe-events-widget-events-list__event-date-tag');
        var date = dateTag?.text.trim();
        var eventTitleElement = eventRow.querySelector(
            '.tribe-events-widget-events-list__event-title-link');
        var title = eventTitleElement?.text.trim();
        var link = eventTitleElement?.attributes['href'];
        eventRowsData.add({
          "link": link,
          "title": title!.replaceAll("-", " -"),
          "date": date!.replaceAll("  ", ""),
        });
      }
      var campusImages = [];
      var imageElements = document.querySelectorAll(
          '.et_pb_column.et_pb_column_4_4.et_pb_column_27 .et_pb_module.et_pb_image');
      for (var imageElement in imageElements) {
        var imageUrl =
            imageElement.querySelector('img')?.attributes['data-src'];
        var imageAlt =
            imageElement.querySelector('img')?.attributes['title']!.trim();

        if (imageUrl != null) {
          campusImages.add({"title": imageAlt, "image": imageUrl});
        }
      }

      var policies = [];
      var policiesSelector = document.querySelectorAll(
          ".et_pb_row.et_pb_row_26.et_pb_equal_columns .et_pb_with_border");
      for (var el in policiesSelector) {
        var title = el.querySelector(".et_pb_text_inner h3")?.text;
        var description = '';
        if (el.querySelector(".et_pb_text_inner p")?.text != null && el.querySelector(".et_pb_text_inner p")?.text != '') {
          description =
              el.querySelector(".et_pb_text_inner p")!.text;
        } else {
            el.querySelector(".et_pb_text_inner")!.text;
        }

        var imgUrl =
            el.querySelector(".et_pb_image_wrap img")?.attributes['data-src'];
        policies
            .add({"title": title, "description": description, "image": imgUrl});
      }

      var imageContainers = document.querySelectorAll(
          '.et_pb_row.et_pb_row_28 .n2-ss-slide-background-image');
      var departmentImages = [];
      for (var container in imageContainers) {
        var sourceTags = container.querySelectorAll('source');
        for (var source in sourceTags) {
          final index = sourceTags.indexOf(source);
          if (index == 0 || index == 4 || index == 8 || index == 12) {
            departmentImages.add(source.attributes['srcset']);
          }
        }
      }

      data = {
        "smallData": smallData,
        "events": posts,
        "topStudents": carouselItems,
        "buildingData": schoolData,
        "upcomingEvents": eventRowsData,
        "campusImages": campusImages,
        "policies": policies,
        "departmentImages": departmentImages
      };
      log(policies.toString());
      return data;
    } else {
      log('Failed to load page: ${response.statusCode}');
    }
  } catch (e) {
    log('Error: $e');
  }
}
