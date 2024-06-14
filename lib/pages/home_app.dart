import 'package:bloodd/controller/login_controller.dart';
import 'package:bloodd/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    title: 'Menu Coulissant',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String email = '';
  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  // Méthode pour charger l'ID de l'utilisateur depuis SharedPreferences
  void _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Accueil"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Ouvrir le Drawer
              },
            );
          },
        ),
      ),
      drawer: _buildDrawer(), // Ajouter le Drawer ici
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      _buildDashboardCard(
                        title: "Employés",
                        imagePath: 'assets/images/staff.png',
                        elements: "3 Éléments",
                        onTap: () {
                          // Gérer le clic sur la carte Employés
                        },
                      ),
                      _buildDashboardCard(
                        title: "Congés",
                        imagePath: 'assets/images/leave.png',
                        elements: "2 Éléments",
                        onTap: () {
                          // Gérer le clic sur la carte Congés
                        },
                      ),
                      _buildDashboardCard(
                        title: "Salaires",
                        imagePath: 'assets/images/salary.png',
                        elements: "2 Éléments",
                        onTap: () {
                          // Gérer le clic sur la carte Salaires
                        },
                      ),
                      _buildDashboardCard(
                        title: "Performance",
                        imagePath: 'assets/images/performance.png',
                        elements: "2 Éléments",
                        onTap: () {
                          // Gérer le clic sur la carte Performance
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String imagePath,
    required String elements,
    required Function() onTap,
  }) {
    return SizedBox(
      width: 160.0,
      height: 160.0,
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Color.fromARGB(255, 21, 21, 21),
          elevation: 2.0,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath, width: 64.0, height: 64.0),
                  SizedBox(height: 10.0),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    elements,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                  radius: 30,
                ),
                SizedBox(height: 10),
                Text(
                  "Nom Utilisateur",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "$email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Réglages"),
            onTap: () {
              Navigator.pop(context); // Fermer le Drawer
              // Action pour Réglages
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("À propos"),
            onTap: () {
              Navigator.pop(context); // Fermer le Drawer
              // Action pour À propos
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Déconnexion"),
            onTap: () async {
              await LoginController().logoutUser();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text("Quitter"),
            onTap: () {
              Navigator.pop(context); // Fermer le Drawer
              SystemNavigator.pop(); // Quitter l'application
            },
          ),
        ],
      ),
    );
  }
}
