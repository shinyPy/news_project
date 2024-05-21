import 'package:flutter/material.dart';
import 'package:news_project/utils/database_helper.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final comments = await dbHelper.getCommentsByArticleId(widget.articleId);
    setState(() {
      _comments = comments;
    });
  }

  void _addComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Comment cannot be empty'),
      ));
      return;
    }
    Map<String, dynamic> newComment = {
      'ArticleID': widget.articleId,
      'UserID': 1,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: 'Add a comment',
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: _addComment,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final comment = _comments[index];
            return ListTile(
              title: Text(comment['CommentText']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteComment(comment['CommentID']),
              ),
            );
          },
        ),
      ],
    );
  }
}
