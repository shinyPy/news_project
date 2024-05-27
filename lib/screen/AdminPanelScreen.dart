import 'package:flutter/material.dart';
import 'package:news_project/screen/Admin/ManageUsersScreen.dart';
import 'package:news_project/screen/HomeScreen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool _isUserPanelExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isUserPanelExpanded = !_isUserPanelExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Manage Users'),
                );
              },
              body: Column(
                children: [
                  ListTile(
                    title: Text('User Management'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageUsersScreen(),
                        ),
                      );
                    },
                  ),
                  // Add more ListTiles for other CRUD operations if needed
                ],
              ),
              isExpanded: _isUserPanelExpanded,
            ),
            // Add more ExpansionPanels for other sections if needed
          ],
        ),
      ),
    );
  }
}
