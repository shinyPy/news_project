import 'package:flutter/material.dart';
import 'package:news_project/utils/global.colors.dart';
import 'package:news_project/components/text.form.global.dart';
import 'package:news_project/components/button.global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/screen/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:news_project/utils/app_providers.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool _isLogin = true;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _signIn(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Isi semua fields.'),
        ),
      );
      return;
    }

    final success = await authProvider.login(email, password);

    if (success) {
      Navigator.pushReplacement(context, _createRoute());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Authentication failed. Please try again.'),
      ));
    }
  }

  void _register(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final username = usernameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }

    final success = await authProvider.register(username, email, password);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration successful. Please login.'),
      ));
      _toggleAuthMode();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed. Please try again.'),
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
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Image(
                    height: 100,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      _isLogin
                          ? 'Login to your account'
                          : 'Create a new account',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: GlobalColors.mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (!_isLogin)
                      TextFormGlobal(
                        controller: usernameController,
                        text: 'Username',
                        obscure: false,
                        textInputType: TextInputType.text,
                      ),
                    const SizedBox(height: 15),
                    TextFormGlobal(
                      controller: emailController,
                      text: 'Email',
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    TextFormGlobal(
                      controller: passwordController,
                      text: 'Password',
                      textInputType: TextInputType.text,
                      obscure: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ButtonGlobal(
                  color: GlobalColors.secondaryColor,
                  text: _isLogin ? 'Sign in' : 'Register',
                  onTap: () => _isLogin ? _signIn(context) : _register(context),
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: _toggleAuthMode,
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Register here"
                        : "Already have an account? Login here",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration:
          Duration(milliseconds: 600), // Duration of the transition
    );
  }
}
