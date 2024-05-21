// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

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
    try {
      final articles = await dbHelper.getNewsArticles();
      setState(() {
        _articles = articles;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching articles: $error')),
      );
    }
  }

  Future<void> _addArticle() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Content cannot be empty')),
      );
      return;
    }

    Map<String, dynamic> newArticle = {
      'Title': _titleController.text,
      'Content': _contentController.text,
      'ImageUrl': _imageUrlController.text,
      'AuthorID': 1,
    };

    try {
      await dbHelper.insertNewsArticle(newArticle);
      _fetchArticles();
      _titleController.clear();
      _contentController.clear();
      _imageUrlController.clear();
      Navigator.of(context).pop(); // Close the modal
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding article: $error')),
      );
    }
  }

  Future<void> _deleteArticle(int id) async {
    try {
      await dbHelper.deleteNewsArticle(id);
      _fetchArticles();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting article: $error')),
      );
    }
  }

  void _showAddArticleModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add New Article',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.title),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _contentController,
                          decoration: const InputDecoration(
                            labelText: 'Content',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.article),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter content';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.image),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _addArticle,
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                const Size.fromHeight(50), // button's height
                          ),
                          child: const Text('Add Article'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(article['Title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article['Content']),
                        if (article['ImageUrl'] != null)
                          Image.network(
                            article['ImageUrl'],
                            errorBuilder: (context, error, stackTrace) {
                              return Text('Image failed to load');
                            },
                          ),
                        CommentsWidget(articleId: article['ArticleID']),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteArticle(article['ArticleID']),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _showAddArticleModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
