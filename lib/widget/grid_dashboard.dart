import 'package:flutter/material.dart';

class GridDashboard extends StatelessWidget {

  Item item1 = Item(
    title: "Personnel",
    subtitle: "Mars",
    event: "3 Mars",
    img: "assets/images/multy-user.png.png"
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
    );
  }
}

class Item {
  String title;
  String subtitle;
  String event;
  String img;

  Item({required this.title, required this.subtitle,required this.event,required this.img});
}
