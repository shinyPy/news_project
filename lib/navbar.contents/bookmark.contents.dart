import 'package:flutter/material.dart';
import 'package:news_project/screen/NewsDetailScreen.dart';
import 'package:news_project/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class BookmarkContents extends StatefulWidget {
  const BookmarkContents({super.key});

  @override
  _BookmarkContentsState createState() => _BookmarkContentsState();
}

class _BookmarkContentsState extends State<BookmarkContents> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _bookmarkedArticles = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    _getUserInfo().then((_) => _fetchBookmarkedArticles());
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('UserID');
    });
  }

  Future<void> _fetchBookmarkedArticles() async {
    if (_userId == null) return;
    try {
      final articles = await dbHelper.getBookmarkedArticles(_userId!);
      setState(() {
        _bookmarkedArticles = articles;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching bookmarked articles: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bookmarkedArticles.isEmpty
          ? Center(child: Text('No bookmarks found'))
          : ListView.builder(
              itemCount: _bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = _bookmarkedArticles[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailScreen(article: article),
                      ),
                    ),
                    leading: article['ImageUrl'] != null &&
                            article['ImageUrl'].isNotEmpty
                        ? Image.file(
                            File(article['ImageUrl']),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image, size: 50);
                            },
                          )
                        : Icon(Icons.image, size: 50),
                    title: Text(article['Title']),
                    subtitle: Text(
                      article['Content'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
