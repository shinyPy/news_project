import 'package:flutter/material.dart';
import 'package:news_project/screen/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:news_project/screen/IntroductionScreen.dart';
import 'package:news_project/utils/app_providers.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Project',
      //     initialRoute: '/',
      //     routes: {
      //   '/': (context) => HomeScreen(),
      //   '/profile': (context) => ProfileContents(),
      //   '/bookmarks': (context) => BookmarksScreen(),
      //   '/comments': (context) => CommentsScreen(),
      //   '/settings': (context) => AccountSettingsScreen(),
      //   '/login': (context) => LoginScreen(),
      //   '/admin': (context) => AdminPanelScreen(),
      // },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return auth.isLoggedIn ? HomeScreen() : IntroductionScreen();
        },
      ),
    );
  }
}
