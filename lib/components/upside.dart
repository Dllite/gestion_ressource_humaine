import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Upside extends StatelessWidget {
  const Upside({super.key, required this.imgUrl});
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height / 2,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              imgUrl,
              alignment: Alignment.topCenter,
              scale: 8,
            ),
          ),
        ),
        iconBackButton(context),
        /*Positioned(
          left: 0,
          height: 175,
          child: Image.network(
            "https://img.freepik.com/free-vector/mobile-login-concept-illustration_114360-135.jpg",
            scale: 3,
          ),
        ),*/
      ],
    );
  }

  iconBackButton(BuildContext context) {
    return IconButton(
      color: Colors.blue,
      iconSize: 28,
      icon: const Icon(CupertinoIcons.arrow_left),
      onPressed: (() {
        Navigator.pop(context);
      }),
    );
  }
}
