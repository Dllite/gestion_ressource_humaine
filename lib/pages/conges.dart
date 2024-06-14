import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Conge extends StatefulWidget {
  @override
  _CongeState createState() => _CongeState();
}

class _CongeState extends State<Conge> {
  List<dynamic> _conges = [];
  List<dynamic> _users = [];
  String? _selectedUserId;
  final TextEditingController _dateDebutController = TextEditingController();
  final TextEditingController _dateFinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchConges(); // Fetch data when the page starts
    _fetchUsers();
  }

  Future<void> _fetchConges() async {
    try {
      var myUrl = Uri.http('gestion.magiksolve.com', '/conge_liste.php');
      var response = await http.get(myUrl, headers: {
        'Accept': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> conges = jsonResponse['conges'];
        setState(() {
          _conges = conges;
        });
      } else {
        print('Failed to load conges: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
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
          _users = users;
        });
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _addLeave(String employeId, String dateDebut, String dateFin) async {
    try {
      var myUrl = Uri.https('gestion.magiksolve.com', '/conge.php');
      var response = await http.post(myUrl, body: {
        'employe_id': employeId,
        'date_debut': dateDebut,
        'date_fin': dateFin,
      });

      if (response.statusCode == 200) {
        print("Congé ajouté avec succès");
        _fetchConges(); // Refresh the list of leaves
        Navigator.of(context).pop(); // Close the dialog after successful addition
      } else {
        print('Échec de l\'ajout du congé: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du congé: $e');
    }
  }

  Future<void> _showAddLeaveDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Ajouter un nouveau congé"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Sélectionner un employé"),
                      items: _users.map((user) {
                        return DropdownMenuItem<String>(
                          value: user['id'].toString(),
                          child: Text("${user['nom']} ${user['prenom']}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUserId = value;
                        });
                      },
                    ),
                    TextField(
                      controller: _dateDebutController,
                      decoration: InputDecoration(labelText: "Date de début"),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _dateDebutController.text = formattedDate;
                          });
                        }
                      },
                    ),
                    TextField(
                      controller: _dateFinController,
                      decoration: InputDecoration(labelText: "Date de fin"),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _dateFinController.text = formattedDate;
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
                    if (_selectedUserId != null && _dateDebutController.text.isNotEmpty && _dateFinController.text.isNotEmpty) {
                      _addLeave(_selectedUserId!, _dateDebutController.text, _dateFinController.text);
                    } else {
                      print("Veuillez remplir tous les champs");
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Liste des congés"),
    ),
    body: ListView.separated(
      itemCount: _conges.length,
      separatorBuilder: (BuildContext context, index) {
        return const Divider(
          height: 1,
        );
      },
      itemBuilder: (context, int index) {
        var conge = _conges[index];
        var employe = _users.firstWhere((user) => user['id'] == conge['employe_id'], orElse: () => null);

        // Vérifier si le congé est en cours ou terminé
        DateTime now = DateTime.now();
        DateTime debut = DateTime.parse(conge['date_debut']);
        DateTime fin = DateTime.parse(conge['date_fin']);
        bool enCours = now.isAfter(debut) && now.isBefore(fin);
        bool termine = now.isAfter(fin);

        // Déterminer la couleur de l'étiquette
        Color couleurEtiquette = enCours ? Colors.green : (termine ? Colors.red : Colors.grey);

        return ListTile(
          title: Text(employe != null ? "${employe['nom']} ${employe['prenom']}" : "Employé inconnu"),
          subtitle: Text("Du ${conge['date_debut']} au ${conge['date_fin']}"),
          trailing: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: couleurEtiquette,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              enCours ? "En cours" : (termine ? "Terminé" : "En attente"),
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddLeaveDialog,
      child: Icon(Icons.add),
    ),
  );
}

}
