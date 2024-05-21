import 'package:flutter/material.dart';
import 'package:news_project/components/social.login.dart';
import 'package:news_project/components/text.form.global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/components/button.global.dart';
import 'package:news_project/screen/HomeScreen.dart';
import 'package:news_project/utils/auth_service.dart';
import 'package:news_project/utils/global.colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService =
      AuthService(); // Create an instance of your authentication service

  @override
  Widget build(BuildContext context) {
    void _login() async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        bool success = await authService.signIn(email, password);
        if (success) {
          Navigator.push(context, _createRoute());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ));
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Image(
                    height: 100,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Login to your account',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: GlobalColors.mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //// Email Input
                    TextFormGlobal(
                      controller: emailController,
                      text: 'Email',
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //// Password Input
                    TextFormGlobal(
                        controller: passwordController,
                        text: 'Password',
                        textInputType: TextInputType.text,
                        obscure: true)
                  ],
                ),
                const SizedBox(height: 20),
                ButtonGlobal(
                  color: GlobalColors.secondaryColor,
                  text: 'Sign in',
                  onTap: _login, // Call _login function on button tap
                ),
                const SizedBox(height: 25),
                SocialLogin(),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 50,
      //   color: Colors.white,
      //   alignment: Alignment.center,
      //   child: Row(
      //     children: [
      //       Text('Test'),
      //     ],
      //   ),
      // ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
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
    transitionDuration: Duration(milliseconds: 600), // Durasi transisi 600ms
  );
}
