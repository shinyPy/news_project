import 'package:flutter/material.dart';
import 'package:news_project/screen/Admin/AddEditUserScreen.dart';
import 'package:news_project/screen/AdminPanelScreen.dart';
import 'package:news_project/utils/database_helper.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final users = await dbHelper.getUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _deleteUser(int userId) async {
    await dbHelper.deleteUser(userId);
    _fetchUsers();
  }

  void _editUser(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddEditUserScreen(user: user),
    ).whenComplete(_fetchUsers);
  }

  void _addUser() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddEditUserScreen(),
    ).whenComplete(_fetchUsers);
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['Username']),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Email: ${user['Email']}'),
              Text('Role: ${user['Role']}'),
              Text('Created At: ${user['CreatedAt']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDatabase() async {
    await dbHelper.deleteDatabase();
    setState(() {
      _users = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPanelScreen(),
              ),
            );
          },
        ),
        title: const Text("Manage Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _deleteDatabase,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
      body: _users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user['Username'][0].toUpperCase()),
                    ),
                    title: Text(user['Username']),
                    subtitle: Text('${user['Email']} - ${user['Role']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () => _showUserDetails(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editUser(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteUser(user['UserID']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
