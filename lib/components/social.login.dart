import "package:flutter/material.dart";
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        alignment: Alignment.center,
        child: const Text(
          '-Or sign in with-',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 15),
      Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Row(
          children: [
            /// Google
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Image(
                  height: 30,
                  image: Svg('assets/images/google.svg'),
                ),
              ),
            ),

            /// Facebook
            // Expanded(
            //   child: Container(
            //       alignment: Alignment.center,
            //       height: 65,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(6),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.1),
            //             blurRadius: 10,
            //           ),
            //         ],
            //       ),
            //       child: Image(
            //         height: 30,
            //         image: Svg('assets/images/facebook.svg'),
            //       )),
            // ),

            // /// Twitter
            // Expanded(
            //   child: Container(
            //       alignment: Alignment.center,
            //       height: 65,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(6),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.1),
            //             blurRadius: 10,
            //           ),
            //         ],
            //       ),
            //       child: Image(
            //         height: 30,
            //         image: Svg('assets/images/twitter.svg'),
            //       )),
            // ),
          ],
        ),
      ),
    ]);
  }
}
