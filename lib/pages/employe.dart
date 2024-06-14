import 'dart:convert';
import 'dart:io';
import 'package:bloodd/models/user.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Employe extends StatefulWidget {
  const Employe({super.key});

  @override
  State<Employe> createState() => _EmployeState();
}

class _EmployeState extends State<Employe> {
  final List<String> postes = [
    "Développeur",
    "Designer",
    "Manager",
    "Product Owner",
    "Ingénieur QA",
    "RH",
    "Marketing",
    "Support",
    "Capitaine"
  ];

  void _addUserLocally(String name, String email, String poste, String image) {
    setState(() {
      users.add(User(name, email, poste, image));
    });
  }

  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch data when the app starts
  }

  Future<void> _fetchUsers() async {
    try {
      var myUrl = Uri.http('gestion.magiksolve.com', '/employes.php');
      var response = await http.get(myUrl, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> users = jsonResponse['employes'];
        setState(() {
          _users = users; // Update state with fetched data
        });
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _addUser(String name, String prenom, String email, String poste, String? imagePath) async {
    try {
      var myUrl = Uri.https('gestion.magiksolve.com', '/nouveau_compte.php');
      var request = http.MultipartRequest('POST', myUrl)
        ..headers['Accept'] = 'application/json'
        ..fields['nom'] = name
        ..fields['prenom'] = prenom
        ..fields['email'] = email
        ..fields['poste'] = poste;

      if (imagePath != null && imagePath.isNotEmpty) {
        // Copier l'image dans le répertoire de l'application
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String newPath = path.join(appDocDir.path, 'assets/uploads', path.basename(imagePath));
        await Directory(path.join(appDocDir.path, 'assets/uploads')).create(recursive: true);
        File newImage = await File(imagePath).copy(newPath);

        request.files.add(await http.MultipartFile.fromPath('image', newImage.path));
        request.fields['image'] = newImage.path; // Envoi du chemin de l'image au serveur
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print("Employé ajouté avec succès");
        _fetchUsers(); // Rafraîchir la liste des utilisateurs
      } else {
        print('Échec de l\'ajout de l\'employé: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'employé: $e');
    }
  }

  Future<void> _showAddUserDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController prenomController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    String selectedPoste = postes[0];
    String? selectedImagePath;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Ajouter un nouvel utilisateur"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Nom"),
                    ),
                    TextField(
                      controller: prenomController,
                      decoration: InputDecoration(labelText: "Prénom"),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    DropdownButton<String>(
                      value: selectedPoste,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPoste = newValue!;
                        });
                      },
                      items: postes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextButton(
                      child: Text(selectedImagePath == null
                          ? "Sélectionner une image"
                          : "Image sélectionnée"),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.image);

                        if (result != null) {
                          setState(() {
                            selectedImagePath = result.files.single.path!;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Annuler"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Ajouter"),
                  onPressed: () {
                    _addUser(
                      nameController.text,
                      prenomController.text,
                      emailController.text,
                      selectedPoste,
                      selectedImagePath,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showUserDetails(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetails(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listes des employés"),
      ),
      body: ListView.separated(
        itemCount: _users.length,
        separatorBuilder: (BuildContext context, index) {
          return const Divider(
            height: 1,
          );
        },
        itemBuilder: (context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(users[index]
                  .image), // Use NetworkImage if the path is from the internet
            ),
            title: Text(_users[index]['nom']),
            subtitle: Text(_users[index]['poste']),
            onTap: () => _showUserDetails(users[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(user
                    .image), // Use NetworkImage if the path is from the internet
                radius: 50,
              ),
              SizedBox(height: 16),
              Text(user.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(user.email, style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text(user.poste, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
