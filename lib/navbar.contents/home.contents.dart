import 'package:flutter/material.dart';
import 'package:news_project/components/news.widget.dart';

class HomeContents extends StatelessWidget {
  const HomeContents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: NewsWidget()),
        ],
      ),
    );
  }
}
