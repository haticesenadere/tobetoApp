import 'package:flutter/material.dart';
import 'package:tobetoapp/models/news.dart';
import 'package:tobetoapp/widgets/news_card.dart';

class NewsListCard extends StatelessWidget {
  const NewsListCard({Key? key, required this.news}) : super(key: key);
  final List<News> news;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (ctx, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: NewsCard(news: news[index]),
      ),
    );
  }
}
