import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class NeerajSchoolScrapper extends ChangeNotifier {
  String schoolName = "Neeraj Modi";
  String baseUrl = 'https://www.nmsindia.org';
  List<dynamic> aboutUsData = [
    {
      "title": "Our History",
      "headings": null,
      "data": [
        "We, at Neerja Modi School, are focused on providing a fertile platform powered by the best-in-class education, facilities and nurturing for students to attain their highest potential.",
        "The journey of our school began in the year 2001 and has achieved an unsurpassed growth over the last 2 decades. It makes us both proud and humbled to witness the school rising to be the No.1 educational institute in Jaipur – Rajasthan and No. 8 in India’s Day and Boarding School, by the Education World School Rankings 2020.",
        "We are a co-educational day boarding school from kindergarten to grade 12. A majority of our students join us at age three and graduate with us as high school seniors. Our students cherish friendships and a life-time bond with their peers and the school.",
        "We also pride ourselves in being an academically competitive school, while we provide an ample extra-curricular and co-curricular opportunities as well. Our students participate and excel in competitive sports and athletics, academic Olympiads, science research programs, national chess championship, extensive debates, and start-up competitions. Sports, visual and performing arts, as well as yoga are an integral part of every student’s life.",
        "We uphold a robust leadership structure within our student community. The self-less conviction to give back and make a meaningful impact on the wider community is part of our student body’s DNA. They diligently engage deeply with campus community service initiatives and also reach out to a number of local NGOs, healthcare centers and government schools."
      ],
      "subPoints": null,
      "images": null
    },
    {
      "title": "Our Vision and Mission",
      "headings": ["Our Vision", "Our Mission", "Our Philosophy"],
      "data": [
        "Cultivate the leaders of tomorrow, today; to enrich each student’s academic and personal development whilst upholding values of integrity; to deepen each student's understanding of the complexities of the world; to nurture each student to reach his or her fullest potential.",
        "We are dedicated to holistic excellence and to the development of self-confident individuals of good character who are prepared to embrace diversity, change and lifelong learning. The school aims to create a learning environment that is challenging, diverse, and supportive, where talented, dedicated faculty and students are encouraged to interact in an atmosphere of mutual respect and trust. At NMS many paths exist in partnership and students are guided to find paths that are most effective for them. The school is committed to building a dynamic learning community that nurtures independent learning, innovation and creativity.",
        "We understand that every child learns differently and is gifted with a unique ability that needs to be carefully honed through an inspiring learning environment. We celebrate the diversity and individuality of our students. With a clear recognition of the needs and the capabilities of students of differing ages and experiences, the school implements its philosophy:"
      ],
      "subPoints": {
        "arrIndex": 2,
        "data": [
          "By  gradually guiding a student from dependent to independent learning",
          "By stressing high academic standards through a strong commitment to the process of learning",
          "By creating an environment for learning which is stimulating, innovative, tolerant, enjoyable and which encourages intellectual inquiry and curiosity",
          "By stressing the fundamental value of integrity & trust",
          "By providing opportunities for personal growth, and preparing students to take their place as global citizens."
        ],
      },
      "images": null
    },
    {
      "title": "Location",
      "headings": null,
      "data": [
        "Neerja Modi School is located in the historical city of Jaipur in the state of Rajasthan. The school stands in one of the largest housing colony of Asia (Mansarovar)."
      ],
      "subPoints": null,
      "images": [
        "https://www.nmsindia.org/assets/images/about_gallery/1457152325268153140.jpg",
        "https://www.nmsindia.org/assets/images/about_gallery/14571523251690012357.jpg",
        "https://www.nmsindia.org/assets/images/about_gallery/14571523261819994090.jpg",
        "https://www.nmsindia.org/assets/images/about_gallery/14571535291275090002.jpg"
      ],
    },
    {
      "title": "Infrastructure",
      "data": [
        "We are proud of our green, expansive 20 acre property and state of the art facilities. We have a football field, a cricket ground (International Standard), a 25 meter lap swimming pool, a 400m athletic track; as well as courts for tennis, basketball, badminton & volleyball, horse riding, cricket nets, table tennis, and squash.",
        "The school hosts inter-school tournaments & our teams participate at the district, state & national levels in the following: chess, squash, tennis, badminton, athletics, basketball, football, archery, cricket, swimming and table tennis.",
        "Sustainability is also upheld throughout our operations through rain-water harvesting, water recycling, and solar-powered buildings. We understand that environmental awareness and conservation is key for the future of our community and generations to come."
      ],
      "subPoints": null,
      "headings": null,
      "images": [
        "https://www.nmsindia.org/assets/images/about_gallery/1649395283516807800.jpg",
        "https://www.nmsindia.org/assets/images/about_gallery/1649395283722166864.JPG",
        "https://www.nmsindia.org/assets/images/about_gallery/1649395283253902785.jpg",
        "https://www.nmsindia.org/assets/images/about_gallery/1649395283890038390.jpg",
        "https://www.nmsindia.org/assets/images/about_gallery/16493952832104646271.jpg",
        "https://www.nmsindia.org/assets/images/about_gallery/16493952831075292355.JPG",
        "https://www.nmsindia.org/assets/images/about_gallery/164939528342633668.JPG",
        "https://www.nmsindia.org/assets/images/about_gallery/16493952831296904383.JPG",
        "https://www.nmsindia.org/assets/images/about_gallery/164939528342355929.jpg",
        "https://www.nmsindia.org/assets/images/about_gallery/1649395283464211853.jpg"
      ]
    },
  ];
  Dio dio = Dio();

  Future<dynamic> fetchHomePage() async {
    // var resp = await dio.get("https://www.nmsindia.org/");
    var imagesResp = await dio.get(
        'https://storage.elfsight.com/api/v2/data/19ec5d41f3b6cf80f70bf4b54fdd9c55');

    // if (resp.statusCode == 200) {
    //   var document = parse(resp.data);
    //   var bigCarouselImages =
    //       document.querySelectorAll(".container .slide-image").map((el) {
    //     return el.attributes['src'];
    //   }).toList();
    //   log(bigCarouselImages.toString());
    // }

    if (imagesResp.statusCode == 200) {
      var data = imagesResp.data;
      var bigCarouselElements = data['data']['posts'];
      List<Map<String, String>> formattedData = [];
      for (var i in bigCarouselElements) {
        formattedData.add({
          "title": i['caption'].trim(),
          "image": i['images']['thumbnail']['url'],
          "link": i['link']
        });
      }
      log(formattedData.toString());
      return formattedData;
    }
  }

  Future<dynamic> fetchEvents() async {
    var resp = await dio.get("https://www.nmsindia.org/");
    if (resp.statusCode == 200) {
      var document = parse(resp.data);
      List<Map<String, String>> events = [];
      var eventsElements = document.querySelectorAll(".rt_banner a");
      for (var i in eventsElements) {
        events.add({"title": i.text.trim(), "link": i.attributes['href']!});
      }
      return events;
    }
  }

  Future<dynamic> fetchEvent(String url) async {
    var resp = await dio.get(url);
    if (resp.statusCode == 200) {
      var document = parse(resp.data);
      dynamic data = {"body": [], "images": []};
      var eventImages = document.querySelectorAll(".slide-image");
      for (var i in eventImages) {
        data['images'].add(i.attributes['src']);
      }
      var paragraphElemennts = document.querySelectorAll("font p");
      for (var p in paragraphElemennts) {
        data['body'].add(p.text);
      }
      log(data.toString());
      return data;
    }
  }
}
