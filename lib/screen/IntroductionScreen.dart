import 'package:flutter/material.dart';
import 'package:news_project/screen/LoginScreen.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _introData = [
    {
      'image': 'assets/images/intro1.jpg',
      'title': 'Selamat Datang',
      'subtitle': 'This is the first intro screen',
    },
    {
      'image': 'assets/images/intro2.png',
      'title': 'Explore Features',
      'subtitle': 'This is the second intro screen',
    },
    {
      'image': 'assets/images/intro3.png',
      'title': 'Tunggu Apa lagi?',
      'subtitle': 'This is the third intro screen',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _introData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 35),
                        Image.asset(_introData[index]['image']!, height: 300),
                        SizedBox(height: 5),
                        Text(
                          _introData[index]['title']!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 4, 4, 4),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _introData[index]['subtitle']!,
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_currentPage != _introData.length - 1) {
                          _pageController.animateToPage(
                            _introData.length - 1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _pageController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(_currentPage == _introData.length - 1
                          ? 'Back'
                          : 'Skip'),
                      style: TextButton.styleFrom(),
                    ),
                    Row(
                      children: List.generate(
                        _introData.length,
                        (index) => GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(4.0),
                            width: _currentPage == index ? 24.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: _currentPage == index
                                  ? Colors.indigo
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_currentPage < _introData.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.push(context, _createRoute());
                        }
                      },
                      child: Text(_currentPage == _introData.length - 1
                          ? 'Sign In'
                          : 'Next'),
                      style: TextButton.styleFrom(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
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
