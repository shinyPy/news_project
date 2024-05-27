import 'package:flutter/material.dart';
import 'package:news_project/screen/NewsDetailScreen.dart';
import 'package:news_project/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _articles = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _imageFile;
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
        SnackBar(content: Text('Error fetching articles: $error')),
      );
    }
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('UserRole') ?? 'user';
      _userId = prefs.getInt('UserID');
    });
  }

  Future<void> _addArticle() async {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Title, Content and Image cannot be empty')),
      );
      return;
    }
    Map<String, dynamic> newArticle = {
      'Title': _titleController.text,
      'Content': _contentController.text,
      'ImageUrl': _imageFile!.path,
      'AuthorID': _userId,
    };
    try {
      await dbHelper.insertNewsArticle(newArticle);
      _fetchArticles();
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _imageFile = null;
      });
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Pick Image'),
                        ),
                        if (_imageFile != null) ...[
                          const SizedBox(height: 16),
                          Image.file(
                            _imageFile!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ],
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
                    trailing: _userRole == 'admin'
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteArticle(article['ArticleID']),
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailScreen(article: article),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: _userRole == 'admin'
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _showAddArticleModal,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
