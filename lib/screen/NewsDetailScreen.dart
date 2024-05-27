import 'package:flutter/material.dart';
import 'package:news_project/components/comments.widget.dart';
import 'dart:io';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['Title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article['ImageUrl'] != null && article['ImageUrl'].isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(article['ImageUrl']),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            'Image failed to load',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                article['Title'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                article['Content'],
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Divider(),
              CommentsWidget(articleId: article['ArticleID']),
            ],
          ),
        ),
      ),
    );
  }
}
