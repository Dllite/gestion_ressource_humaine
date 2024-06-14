import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class SalairePage extends StatefulWidget {
  const SalairePage({Key? key}) : super(key: key);

  @override
  _SalairePageState createState() => _SalairePageState();
}

class _SalairePageState extends State<SalairePage> {
  List<dynamic> _salaires = [];
  List<dynamic> _employes = [];
  final List<String> modesPaiement = [
    "Espèces",
    "Virement bancaire",
    "Chèque",
    "Autre",
  ];
  final List<String> statutsPaiement = [
    "En cours",
    "Terminé",
  ];

  @override
  void initState() {
    super.initState();
    _fetchSalaires();
    _fetchEmployes();
  }

  Future<void> _fetchSalaires() async {
    try {
      var myUrl = Uri.http('gestion.magiksolve.com', '/salaire_liste.php');
      var response = await http.get(myUrl, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> salaires = jsonResponse['salaires'];
        setState(() {
          _salaires = salaires;
        });
      } else {
        print('Failed to load salaries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _fetchEmployes() async {
    try {
      var myUrl = Uri.http('gestion.magiksolve.com', '/employes.php');
      var response = await http.get(myUrl, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> employes = jsonResponse['employes'];
        setState(() {
          _employes = employes;
        });
      } else {
        print('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _addSalaire(String montant, String employeId, DateTime datePaiement,
      String modePaiement, String statutPaiement) async {
    try {
      var myUrl = Uri.https('gestion.magiksolve.com', '/salaire.php');
      Directory appDocDir = await getApplicationDocumentsDirectory();
      var request = http.MultipartRequest('POST', myUrl)
        ..fields['montant'] = montant
        ..fields['employe_id'] = employeId
        ..fields['date_paiement'] = datePaiement.toIso8601String()
        ..fields['mode_paiement'] = modePaiement
        ..fields['statut_paiement'] = statutPaiement;

      // If there is an image upload field, adjust accordingly
      // request.files.add(await http.MultipartFile.fromPath('image', newImage.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        print("Salaire ajouté avec succès");
        _fetchSalaires();
      } else {
        print('Échec de l\'ajout du salaire: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding salaire: $e');
    }
  }

  Future<void> _showAddSalaireDialog() async {
    final TextEditingController montantController = TextEditingController();
    String selectedEmployeId = _employes.isNotEmpty ? _employes[0]['id'].toString() : '';
    DateTime selectedDate = DateTime.now();
    String selectedModePaiement = modesPaiement[0];
    String selectedStatutPaiement = statutsPaiement[0];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Ajouter un nouveau salaire"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: montantController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Montant"),
                    ),
                    DropdownButtonFormField(
                      value: selectedEmployeId,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedEmployeId = newValue!;
                        });
                      },
                      items: _employes.map((employe) {
                        return DropdownMenuItem(
                          value: employe['id'].toString(),
                          child: Text("${employe['nom']} ${employe['prenom']}"),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: "Employé"),
                    ),
                    SizedBox(height: 16),
                    Text("Date de paiement :"),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    DropdownButtonFormField(
                      value: selectedModePaiement,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedModePaiement = newValue!;
                        });
                      },
                      items: modesPaiement.map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(mode),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: "Mode de paiement"),
                    ),
                    DropdownButtonFormField(
                      value: selectedStatutPaiement,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStatutPaiement = newValue!;
                        });
                      },
                      items: statutsPaiement.map((statut) {
                        return DropdownMenuItem(
                          value: statut,
                          child: Text(statut),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: "Statut de paiement"),
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
                    _addSalaire(
                      montantController.text,
                      selectedEmployeId,
                      selectedDate,
                      selectedModePaiement,
                      selectedStatutPaiement,
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

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Liste des salaires"),
    ),
    body: ListView.separated(
      itemCount: _salaires.length,
      separatorBuilder: (BuildContext context, index) {
        return const Divider(
          height: 1,
        );
      },
      itemBuilder: (context, int index) {
  var salaire = _salaires[index];
  var employe = _employes.firstWhere(
    (emp) => emp['id'] == salaire['employe_id'],
    orElse: () => null,
  );

  // Déterminer la couleur et le libellé du badge en fonction du statut de paiement
  Color badgeColor;
  String badgeLabel;
  switch (salaire['statut_paiement']) {
    case 'En cours':
      badgeColor = Colors.green;
      badgeLabel = 'En cours';
      break;
    case 'En attente':
      badgeColor = Colors.yellow;
      badgeLabel = 'En attente';
      break;
    case 'Terminé':
      badgeColor = Colors.blue;
      badgeLabel = 'Terminé';
      break;
    default:
      badgeColor = Colors.grey;
      badgeLabel = 'Inconnu';
  }

  return ListTile(
    title: Text(
      salaire != null ? "${salaire['employe_nom']} ${salaire['employe_prenom']}" : "Employé inconnu",
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Montant: ${salaire['montant']}"),
        Text("Date de paiement: ${salaire['date_paiement']}"),
        Text("Mode de paiement: ${salaire['mode_paiement']}"),
      ],
    ),
    trailing: Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: badgeColor,
      ),
      child: Text(
        badgeLabel,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
},

    ),
     floatingActionButton: FloatingActionButton(
        onPressed: _showAddSalaireDialog,
        child: Icon(Icons.add),
     ),
  );
}

}
