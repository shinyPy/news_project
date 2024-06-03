import 'package:flutter/material.dart';
import 'package:news_project/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsWidget extends StatefulWidget {
  final int articleId;
  const CommentsWidget({required this.articleId});

  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  int? _currentUserId;
  String? _currentUserRole;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _fetchCurrentUser();
  }

  Future<void> _fetchComments() async {
    final comments = await dbHelper.getCommentsUsername(widget.articleId);
    setState(() {
      _comments = comments;
    });
  }

  Future<void> _fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getInt('UserID');
      _currentUserRole = prefs.getString('UserRole');
    });
  }

  void _addComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Comment cannot be empty'),
      ));
      return;
    }
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User not logged in'),
      ));
      return;
    }
    Map<String, dynamic> newComment = {
      'ArticleID': widget.articleId,
      'UserID': _currentUserId,
      'CommentText': _commentController.text,
    };
    await dbHelper.insertComment(newComment);
    _fetchComments();
    _commentController.clear();
  }

  void _deleteComment(int id) async {
    await dbHelper.deleteComment(id);
    _fetchComments();
  }

  bool _canDeleteComment(Map<String, dynamic> comment) {
    return _currentUserRole == 'admin' || _currentUserId == comment['UserID'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Add a comment',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _addComment,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final comment = _comments[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      comment['Username'][0].toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    comment['Username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        comment['CommentText'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  trailing: _canDeleteComment(comment)
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteComment(comment['CommentID']),
                        )
                      : null,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
