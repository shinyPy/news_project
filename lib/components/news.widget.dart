import 'package:flutter/material.dart';
import 'package:news_project/screen/Admin/ManageNewsScreen.dart';
import 'package:news_project/screen/NewsDetailScreen.dart';
import 'package:news_project/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _articles = [];
  String? _userRole;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _getUserInfo();
  }

  Future<void> _fetchArticles() async {
    try {
      final articles = await dbHelper.getNewsArticles();
      setState(() {
        _articles = articles;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetch news: $error')),
      );
    } //refresh ulang
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('UserRole') ?? 'user';
      _userId = prefs.getInt('UserID');
    });
  }

  Future<void> _toggleBookmark(int articleId) async {
    bool isBookmarked = await dbHelper.isArticleBookmarked(_userId!, articleId);
    if (isBookmarked) {
      await dbHelper.deleteBookmark(_userId!, articleId);
    } else {
      await dbHelper.insertBookmark({
        'UserID': _userId,
        'ArticleID': articleId,
      });
    }
    _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return FutureBuilder<bool>(
                  future: dbHelper.isArticleBookmarked(
                      _userId!, article['ArticleID']),
                  builder: (context, snapshot) {
                    bool isBookmarked = snapshot.data ?? false;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
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
                        trailing: IconButton(
                          icon: Icon(isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border),
                          onPressed: () =>
                              _toggleBookmark(article['ArticleID']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: _userRole == 'admin'
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageNewsScreen()),
                );
              },
              child: const Icon(Icons.manage_search),
            )
          : null,
    );
  }
}
