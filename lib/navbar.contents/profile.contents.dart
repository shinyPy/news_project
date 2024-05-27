import 'package:flutter/material.dart';
import 'package:news_project/screen/Admin/ManageUsersScreen.dart';
import 'package:news_project/screen/AdminPanelScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileContents extends StatelessWidget {
  const ProfileContents({super.key});

  Future<Map<String, dynamic>> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('Username') ?? 'Unknown User',
      'email': prefs.getString('Email') ?? 'unknown@example.com',
      'role': prefs.getString('UserRole') ?? 'user',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile information'));
        } else {
          final userInfo = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Text(
                    userInfo['username'][0].toUpperCase(),
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userInfo['username'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userInfo['email'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                // if (userInfo['role'] == 'admin')
                //   ElevatedButton.icon(
                //     onPressed: () {
                //       Navigator.of(context).pushNamed('/admin');
                //     },
                //     icon: const Icon(Icons.admin_panel_settings),
                //     label: const Text('Admin Panel'),
                //   ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: const Text('Bookmarks'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/bookmarks');
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.comment),
                //   title: const Text('My Comments'),
                //   onTap: () {
                //     Navigator.of(context).pushNamed('/comments');
                //   },
                // ),
                const Divider(),
                if (userInfo['role'] == 'admin')
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Admin Panel'),
                    onTap: () {
                      Navigator.pushReplacement(context, _createRoute());
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    await prefs.remove('UserID');
                    await prefs.remove('Username');
                    await prefs.remove('Email');
                    await prefs.remove('UserRole');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AdminPanelScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 800), // Durasi transisi 600ms
  );
}
