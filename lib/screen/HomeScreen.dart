import 'package:flutter/material.dart';
import 'package:news_project/navbar.contents/bookmark.contents.dart';
import 'package:news_project/navbar.contents/home.contents.dart';
import 'package:news_project/navbar.contents/profile.contents.dart';
import 'package:provider/provider.dart';
import 'package:news_project/utils/app_providers.dart';
import 'package:news_project/screen/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('Username') ?? 'User';
    });
  }

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
        return BookmarkContents();
      case 2:
        return ProfileContents();
      default:
        return Container();
    }
  }

  // void _logout(BuildContext context) async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   await authProvider.logout();
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => AuthScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/icon1.png', // Your app logo
              height: 52,
              width: 52,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
            Text(
              'Hello, $_username!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // actions: [
        //   Tooltip(
        //     message: 'Logout',
        //     child: IconButton(
        //       icon: Icon(Icons.logout),
        //       onPressed: () => _logout(context),
        //     ),
        //   ),
        //   SizedBox(width: 16), // Add some spacing between icon buttons
        // ],
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
