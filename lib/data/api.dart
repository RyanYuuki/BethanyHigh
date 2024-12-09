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
        if (policiesSelector.indexOf(el) == policiesSelector.length - 1) {
          description = el.querySelectorAll(".et_pb_text_inner")[1].text;
          log("true - $description");
        } else {
          description = el.querySelector(".et_pb_text_inner p")!.text;
          log(description);
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
            departmentImages.add("https:${source.attributes['srcset']}");
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

Future<dynamic> fetchEvents() async {
  try {
    final dio = Dio();
    final response =
        await dio.get('https://bethanyinstitutions.edu.in/news-and-events/');

    if (response.statusCode == 200) {
      final document = parse(response.data);

      final postElements = document.querySelectorAll('.et_pb_post');

      List<Map<String, String>> posts = postElements.map((element) {
        final titleElement = element.querySelector('.entry-title a');
        final title = titleElement?.text.trim() ?? '';

        final url = titleElement?.attributes['href'] ?? '';

        final imageElement =
            element.querySelector('.et_pb_image_container img');
        final imageUrl = imageElement?.attributes['data-src'] ?? '';

        final authorElement = element.querySelector('.author.vcard a');
        final author = authorElement?.text.trim() ?? '';

        final dateElement = element.querySelector('.post-meta .published');
        final date = dateElement?.text.trim() ?? '';

        final descriptionElement =
            element.querySelector('.post-content-inner p');
        final description = descriptionElement?.text.trim() ?? '';

        return {
          'title': title,
          'link': url,
          'image': imageUrl,
          'author': author,
          'date': date,
          'description': description,
        };
      }).toList();

      posts
          .removeWhere((element) => element['title']!.contains("Top Achiever"));
      log(posts.toString());
      return posts;
    } else {
      log('Failed to load webpage: ${response.statusCode}');
    }
  } catch (e) {
    log('Error: $e');
  }
}

Future<dynamic> fetchEventData(String url) async {
  Dio dio = Dio();
  final resp = await dio.get(url);
  if (resp.statusCode == 200) {
    var document = parse(resp.data);
    final title = document
        .querySelector('.et_pb_text_0_tb_body .et_pb_text_inner')
        ?.text
        .trim();
    final date = document
        .querySelector('.et_pb_text_1_tb_body .et_pb_text_inner')
        ?.text
        .trim();
    final categoryLink = document
        .querySelector('.et_pb_text_2_tb_body .et_pb_text_inner a')
        ?.attributes['href'];
    final categoryName = document
        .querySelector('.et_pb_text_2_tb_body .et_pb_text_inner a')
        ?.text
        .trim();
    final institutionName = document
        .querySelector('.et_pb_text_3_tb_body .et_pb_text_inner')
        ?.text
        .trim();

    final storyElements = document.querySelectorAll(
        '.et_pb_module.et_pb_post_content.et_pb_post_content_0_tb_body p span, i span, p');
    var paragraphs = storyElements
        .map((e) => e.text.trim())
        .where((text) => text.isNotEmpty)
        .where((text) => containsMostlyEnglishText(text))
        .toList();
    if (paragraphs.isEmpty ||
        (paragraphs.length < 5 &&
            paragraphs.any((el) => el.contains('Copyright')))) {
      final elements = document.querySelectorAll(
          '.et_pb_module.et_pb_post_content.et_pb_post_content_0_tb_body div');
      paragraphs = elements
          .map((el) => el.text.trim())
          .where((text) => text.isNotEmpty)
          .where((text) => containsMostlyEnglishText(text))
          .toList();
    }
    final data = {
      'title': title,
      'date': date,
      'image': document
              .querySelector(
                  ".et_pb_module.et_pb_image.et_pb_image_0_tb_body img")
              ?.attributes['data-src'] ??
          document
              .querySelector(
                  ".et_pb_module.et_pb_image.et_pb_image_0_tb_body img")
              ?.attributes['src'],
      'category': {'name': categoryName, 'link': categoryLink},
      'institution': institutionName,
      'body': paragraphs,
    };
    log(data.toString());
    return data;
  }
}

Future<dynamic> fetchAboutDataByUrl(String url) async {
  Dio dio = Dio();
  var resp = await dio.get(url);

  if (resp.statusCode == 200) {
    var document = parse(resp.data);
    var body = document
        .querySelectorAll(".et_pb_text_inner p")
        .map((el) => el.text.trim())
        .toList();
    var image = document
        .querySelector(".et_pb_module.et_pb_image.et_pb_image_0 img")!
        .attributes['data-src'];

    return {"body": body, "image": image};
  }
}

Future<List<Map<String, String>>> fetchDepartments() async {
  Dio dio = Dio();
  Response response =
      await dio.get("https://bethanyinstitutions.edu.in/contact-us/");

  if (response.statusCode == 200) {
    var document = parse(response.data);

    final List<Map<String, String>> departments = [];

    final Map<String, List<dynamic>> institutionMap = {
      'Bethany High School, Koramangala': [
        document.querySelector('.et_pb_text_3')!,
        document.querySelector('.et_pb_blurb_0')!,
        document.querySelector('.et_pb_blurb_1')!,
        document.querySelector('.et_pb_blurb_2')!,
      ],
      'Bethany High School, Sarjapur': [
        document.querySelector('.et_pb_text_4')!,
        document.querySelector('.et_pb_blurb_3')!,
        document.querySelector('.et_pb_blurb_4')!,
        document.querySelector('.et_pb_blurb_5')!,
      ],
      'Bethany Professional Childcare': [
        document.querySelector('.et_pb_text_5')!,
        document.querySelector('.et_pb_blurb_6')!,
        document.querySelector('.et_pb_blurb_7')!,
        document.querySelector('.et_pb_blurb_8')!,
      ],
      'Bethany Pre-Primary Department': [
        document.querySelector('.et_pb_text_6')!,
        document.querySelector('.et_pb_blurb_9')!,
        document.querySelector('.et_pb_blurb_10')!,
        document.querySelector('.et_pb_blurb_11')!,
      ],
      'Bethany High-School Department': [
        document.querySelector('.et_pb_text_7')!,
        document.querySelector('.et_pb_blurb_12')!,
        document.querySelector('.et_pb_blurb_13')!,
        document.querySelector('.et_pb_blurb_14')!,
      ],
      'Bethany Middle-School Department': [
        document.querySelector('.et_pb_text_8')!,
        document.querySelector('.et_pb_blurb_15')!,
        document.querySelector('.et_pb_blurb_16')!,
        document.querySelector('.et_pb_blurb_17')!,
      ],
      'Bethany Junior College': [
        document.querySelector('.et_pb_text_9')!,
        document.querySelector('.et_pb_blurb_18')!,
        document.querySelector('.et_pb_blurb_19')!,
        document.querySelector('.et_pb_blurb_20')!,
      ],
      'Bethany Junior School 2 – HSR': [
        document.querySelector('.et_pb_text_10')!,
        document.querySelector('.et_pb_blurb_21')!,
        document.querySelector('.et_pb_blurb_22')!,
        document.querySelector('.et_pb_blurb_23')!,
      ],
      'Bethany Special School': [
        document.querySelector('.et_pb_text_11')!,
        document.querySelector('.et_pb_blurb_24')!,
        document.querySelector('.et_pb_blurb_25')!,
        document.querySelector('.et_pb_blurb_26')!,
      ],
      'Bethany Integrated Hostel': [
        document.querySelector('.et_pb_text_12')!,
        document.querySelector('.et_pb_blurb_27')!,
        document.querySelector('.et_pb_blurb_28')!,
        document.querySelector('.et_pb_blurb_29')!,
      ],
      'Bethany Primary Department': [
        document.querySelector('.et_pb_text_13')!,
        document.querySelector('.et_pb_blurb_30')!,
        document.querySelector('.et_pb_blurb_31')!,
        document.querySelector('.et_pb_blurb_32')!,
      ],
    };

    institutionMap.forEach((name, elements) {
      departments.add({
        'name': name,
        'location': elements[1]
            .querySelector('.et_pb_blurb_description p')!
            .text
            .trim(),
        'email': elements[2]
            .querySelector('.et_pb_blurb_description p')!
            .text
            .trim(),
        'phone': elements[3]
            .querySelector('.et_pb_blurb_description p')!
            .text
            .trim(),
      });
    });

    return departments;
  } else {
    throw Exception("Failed to load departments");
  }
}

bool containsMostlyEnglishText(String text) {
  if (text.startsWith('<') ||
      text.contains('*') ||
      text.contains('Website') ||
      text.contains('Comment') ||
      text.contains('Save my name,')) {
    return false;
  }
  final alphaText = text.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  if (alphaText.isEmpty) return false;

  final alphabeticRatio = alphaText.length / text.length;

  return alphabeticRatio > 0.5;
}

class Data {
  String heading1 = "Bethany High School Overview";
  String description1 =
      "Bethany High is an ICSE and ISC affiliated school located in the sixth block of Koramangala, Bangalore, India. It has over 2500 students from Nursery through Class 12. Bethany High has an ISC Junior College, of Classes 11 and 12. It also has a hostel (Bethany Integrated Home) for boarders and Bethany Special School for children with special needs, located in the fourth block of Koramangala. The school was founded by Mrs. Mignon David in 1963 and served as a hostel for children from Cottons and Baldwins. The Bethany colors are green and black, with similar-colored uniforms. The Bethany High motto is “Trust and Obey”. This phrase appears in both, its school song and school hymn. Bethany High School turned 50 in 2013 and opened up a new campus on Sarjapur Road, which was inaugurated by Mahatma Gandhi’s granddaughter Sumitra Kulkarni. In 2023, Bethany Institutions celebrated it’s Diamond Jubilee, 60 years of being a lighthouse of education in Bangalore.";
  String image1 =
      "https://bethanyinstitutions.edu.in/wp-content/uploads/2024/11/IMG-20240524-WA0006-scaled.jpg";
  String heading2 = "System Of Education";
  String description2 =
      "Bethany High follows the ICSE curriculum up till Class 10. Students are offered a choice of subjects from Groups II and III. Students can choose any two of Mathematics, Science (Physics, Chemistry, Biology), Economics or Commercial Studies. From Group III, students can opt for any one subject out of Computer Applications, Art, Drama, Western Music or Physical Education. Students are also given a choice of Second Language from Hindi and Kannada. The academic year begins in June and lasts to March of the following year. For classes 8, 9 and 10 (of the high school), there are two Unit Tests (of 20 marks) and two Term Exams (of 80 marks each). The Class 10 students will appear for the ICSE Board Examinations as their 10th standard finals in March. For Classes 11 and 12 the school follows ISC. There are three streams a student can opt for; Science, Commerce or Arts (Humanities). The school offers subjects such as Physics, Chemistry, Biology, Computer Science, Mathematics, Commerce, Accounts, Business Studies, Psychology, Sociology, Fine Arts, Physical Education and Mass Media. The Class 12 students appear for the ISC Board Examinations in March.";
  String image2 =
      "https://bethanyinstitutions.edu.in///wp-content/uploads/2023/10/DSC_6862-768x511-1.webp";
}
