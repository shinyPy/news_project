import 'package:flutter/material.dart';
import 'package:news_project/utils/database_helper.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AddEditUserScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  const AddEditUserScreen({this.user, super.key});

  @override
  _AddEditUserScreenState createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  final dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'user';

  String _generatePasswordHash(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _usernameController.text = widget.user!['Username'];
      _emailController.text = widget.user!['Email'];
      _role = widget.user!['Role'];
    }
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final user = {
        'Username': _usernameController.text,
        'Email': _emailController.text,
        'Role': _role,
        'PasswordHash': _generatePasswordHash(_passwordController.text),
      };
      if (widget.user == null) {
        await dbHelper.insertUser(user);
      } else {
        await dbHelper.updateUser(widget.user!['UserID'], user);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _role,
              items: ['user', 'admin']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _role = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveUser,
              child: Text(widget.user == null ? 'Add User' : 'Save User'),
            ),
          ],
        ),
      ),
    );
  }
}
