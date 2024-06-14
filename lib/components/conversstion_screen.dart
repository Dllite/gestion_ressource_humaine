import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(padding: EdgeInsets.only(left: 10),
        child: Icon(
          Icons.arrow_back,
          color: Colors.black.withOpacity(0.6),

        ),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: NetworkImage("https://www.iconspng.com/images/-abstract-user-icon-1/-abstract-user-icon-1.jpg"),),
              ),
            )
          ],
        ), 

      ),
    );
  }
}