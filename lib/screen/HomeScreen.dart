import 'package:flutter/material.dart';
import 'package:news_project/navbar.contents/home.contents.dart';
import 'package:provider/provider.dart';
import 'package:news_project/utils/app_providers.dart';
import 'package:news_project/screen/AuthScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return HomeContents();
      case 1:
        return Center(
          child: Text(
            'Bookmark',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        );
      case 2:
        return Center(
          child: Text(
            'Profile Page',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        );
      default:
        return Container();
    }
  }

  void _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Appbar'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
