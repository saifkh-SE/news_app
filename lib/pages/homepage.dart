import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:news_app/models/news_model.dart';
import 'package:news_app/pages/article_page.dart';
import 'package:news_app/services/api_manager.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<NewsModel> _newsModel;

  @override
  void initState() {
    _newsModel = API_Manager().getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: Icon(MyApp.themeNotifier.value == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              MyApp.themeNotifier.value =
                  MyApp.themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: FutureBuilder<NewsModel>(
        future: _newsModel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.articles!.length,
              itemBuilder: (context, index) {
                var article = snapshot.data!.articles![index];
                var formattedTime = DateFormat('dd MMM - HH:mm').format(article.publishedAt!);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ArticlePage(
                          title: article.title,
                          url: article.url,
                          urlToImage: article.urlToImage,
                          publishedAt: article.publishedAt,
                          content: article.content,
                        );
                      },
                    ));
                  },
                  child: Container(
                    height: 100,
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              article.urlToImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(formattedTime),
                              Text(
                                article.title!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                article.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
