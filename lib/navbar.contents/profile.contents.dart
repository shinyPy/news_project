import 'package:flutter/material.dart';
import 'package:news_project/screen/AdminPanelScreen.dart';
import 'package:news_project/screen/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_project/utils/app_providers.dart';
import 'package:provider/provider.dart';

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

                const Divider(),
                // ElevatedButton.icon(
                //   onPressed: () => _logout(context),
                //   icon: const Icon(Icons.logout),
                //   label: const Text('Logout '),
                // ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () => _logout(context),
                ),
                if (userInfo['role'] == 'admin')
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Admin Panel'),
                    onTap: () {
                      Navigator.pushReplacement(context, _createRoute());
                    },
                  ),

                const Divider(),
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
