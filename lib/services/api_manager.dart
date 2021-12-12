import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model.dart';

// ignore: camel_case_types
class API_Manager {
  static String apiKey = '5a94bbdb40d84249a9b60f93e251c62c';
  static String news_url = 'http://newsapi.org/v2/everything?domains=wsj.com&sortBy=publishedAt&apiKey=$apiKey';

  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;

    try {
      var response = await client.get(Uri.parse(news_url));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        //return jsonMap;
        newsModel = NewsModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      print(Exception);
    }
    return newsModel;
  }
}
