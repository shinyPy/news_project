import 'package:flutter/material.dart';
import 'package:news_project/components/comments.widget.dart';
import 'package:news_project/utils/database_helper.dart';

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _articles = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    final articles = await dbHelper.getNewsArticles();
    setState(() {
      _articles = articles;
    });
  }

  void _addArticle() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Title and Content cannot be empty'),
      ));
      return;
    }
    Map<String, dynamic> newArticle = {
      'Title': _titleController.text,
      'Content': _contentController.text,
      'ImageUrl': _imageUrlController.text,
      'AuthorID': 1,
    };
    await dbHelper.insertNewsArticle(newArticle);
    _fetchArticles();
    _titleController.clear();
    _contentController.clear();
    _imageUrlController.clear();
  }

  void _deleteArticle(int id) async {
    await dbHelper.deleteNewsArticle(id);
    _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              ElevatedButton(
                onPressed: _addArticle,
                child: const Text('Add Article'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _articles.length,
            itemBuilder: (context, index) {
              final article = _articles[index];
              return ListTile(
                title: Text(article['Title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article['Content']),
                    if (article['ImageUrl'] != null)
                      Image.network(article['ImageUrl']),
                    CommentsWidget(articleId: article['ArticleID']),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteArticle(article['ArticleID']),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
