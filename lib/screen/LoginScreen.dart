import 'package:flutter/material.dart';
import 'package:news_project/components/social.login.dart';
import 'package:news_project/components/text.form.global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/components/button.global.dart';
import 'package:news_project/screen/HomeScreen.dart';
import 'package:news_project/utils/app_providers.dart';
import 'package:news_project/utils/global.colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _signIn(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    final success = await _authService.signIn(email, password);

    if (success) {
      Navigator.pushReplacement(context, _createRoute());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Authentication failed. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    TextFormGlobal(
                      controller: emailController,
                      text: 'Email',
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                  onTap: () => _signIn(context),
                ),
                const SizedBox(height: 25),
                SocialLogin(),
              ],
            ),
          ),
        ),
      ),
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
    transitionDuration:
        Duration(milliseconds: 600), // Duration of the transition
  );
}
