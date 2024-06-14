
import 'package:bloodd/pages/about.dart';
import 'package:bloodd/pages/conges.dart';
import 'package:bloodd/pages/employe.dart';
import 'package:bloodd/pages/performance.dart';
import 'package:bloodd/pages/salaire.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';

import '../pages/home_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final screens = [
    Home(),
    Employe(),
    Conge(),
    SalairePage(),
    PerformancePage()
    
  ];
  //final List<Widget> screensL = [Home(), Employe()];

  //final PageStorageBucket bucket = PageStorageBucket();
  //Widget currentScreen = Activity();
  @override
  Widget build(BuildContext context) => Scaffold(
        //appBar: AppBar(),
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),

        
        bottomNavigationBar: BottomNavigationBar(
          //type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: Colors.blue,
          backgroundColor: Color.fromARGB(255, 228, 48, 48),
          //fixedColor: Colors.pink,
          unselectedItemColor: Colors.black,
          //showSelectedLabels: false,
          //showUnselectedLabels: false,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Employe',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leave_bags_at_home),
              label: 'Conge',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Salaire',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.run_circle),
              label: 'Perform',
              backgroundColor: Colors.white,
            ),
          ],
        ),
        /*
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Accueil
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (() {
                      setState(() {
                        currentScreen = Home();
                        currentTab = 0;
                      });
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "Accueil",
                          style: TextStyle(
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.grey,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  //Activite
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (() {
                      setState(() {
                        currentScreen = Activity();
                        currentTab = 1;
                      });
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dashboard,
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "Demande/Don",
                          style: TextStyle(
                              color:
                                  currentTab == 1 ? Colors.blue : Colors.grey,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  //Chat
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (() {
                      setState(() {
                        currentScreen = Chat();
                        currentTab = 2;
                      });
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "Chat",
                          style: TextStyle(
                              color:
                                  currentTab == 2 ? Colors.blue : Colors.grey,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  //Profil
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (() {
                      setState(() {
                        currentScreen = Profile();
                        currentTab = 4;
                      });
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentTab == 4 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "Profil",
                          style: TextStyle(
                              color:
                                  currentTab == 4 ? Colors.blue : Colors.grey,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  //A propos
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (() {
                      setState(() {
                        currentScreen = About();
                        currentTab = 5;
                      });
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: currentTab == 5 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "A propos",
                          style: TextStyle(
                              color:
                                  currentTab == 5 ? Colors.blue : Colors.grey,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
   */
      );
}
