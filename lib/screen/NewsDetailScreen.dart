import 'package:flutter/material.dart';
import 'package:news_project/components/comments.widget.dart';
class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['Title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['ImageUrl'] != null)
              Image.network(
                article['ImageUrl'],
                errorBuilder: (context, error, stackTrace) {
                  return Text('Image failed to load');
                },
              ),
            const SizedBox(height: 16),
            Text(
              article['Title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              article['Content'],
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            CommentsWidget(articleId: article['ArticleID']),
          ],
        ),
      ),
    );
  }
}