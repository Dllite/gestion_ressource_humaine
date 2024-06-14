import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    title: 'Performance App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => PerformancePage(),
      '/addPerformance': (context) => AddPerformancePage(),
    },
  ));
}

class PerformancePage extends StatefulWidget {
  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  List<dynamic> _performances = [];
  List<dynamic> _employes = [];

  @override
  void initState() {
    super.initState();
    _fetchPerformances();
    _fetchEmployes();
  }

  Future<void> _fetchPerformances() async {
    try {
      var myUrl = Uri.http('gestion.magiksolve.com', '/performance_liste.php');
      var response = await http.get(myUrl, headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _performances = jsonResponse['performances'];
        });
      } else {
        print('Failed to load performances: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching performances: $e');
    }
  }

  Future<void> _fetchEmployes() async {
    try {
      var myUrl = Uri.http('gestion.magiksolve.com', '/employes.php');
      var response = await http.get(myUrl, headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _employes = jsonResponse['employes'];
        });
      } else {
        print('Failed to load employes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des performances"),
      ),
      body: ListView.separated(
        itemCount: _performances.length,
        separatorBuilder: (BuildContext context, index) {
          return const Divider(
            height: 1,
          );
        },
        itemBuilder: (context, int index) {
          var performance = _performances[index];
          return ListTile(
            title: Text("${performance['employe_nom']} ${performance['employe_prenom']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date: ${performance['date']}"),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                "${performance['score']}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addPerformance').then((value) {
           
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddPerformancePage extends StatefulWidget {
  @override
  _AddPerformancePageState createState() => _AddPerformancePageState();
}

class _AddPerformancePageState extends State<AddPerformancePage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  late int _selectedEmployeId;
  List<dynamic> _employes = [];

  @override
  void initState() {
    super.initState();
    _selectedEmployeId = _employes.isNotEmpty ? _employes[0]['id'] : 0;
    _fetchEmployes();
  }

  Future<void> _fetchEmployes() async {
    try {
      var myUrl = Uri.http('gestion.magiksolve.com', '/employes.php');
      var response = await http.get(myUrl, headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _employes = jsonResponse['employes'];
          if (_employes.isNotEmpty) {
            _selectedEmployeId = _employes[0]['id'];
          }
        });
      } else {
        print('Failed to load employes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une performance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: "Date"),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _scoreController,
              decoration: InputDecoration(labelText: "Score"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropdownButton<int>(
              value: _selectedEmployeId,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedEmployeId = newValue;
                  });
                }
              },
              items: _employes.map<DropdownMenuItem<int>>((dynamic employe) {
                return DropdownMenuItem<int>(
                  value: employe['id'],
                  child: Text("${employe['nom']} ${employe['prenom']}"),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Vérifier que les champs sont remplis
                if (_dateController.text.isNotEmpty && _scoreController.text.isNotEmpty) {
                  // Convertir le score en int
                  int score = int.tryParse(_scoreController.text) ?? 0;

                  // Ajouter la performance
                  _addPerformance(DateTime.parse(_dateController.text), score, _selectedEmployeId);
                  Navigator.pop(context, true); // Retour à la page précédente avec succès
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez remplir tous les champs')),
                  );
                }
              },
              child: Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPerformance(DateTime date, int score, int employeId) async {
    try {
      var myUrl = Uri.http('gestion.magiksolve.com', '/performance.php');
      var formattedDate = DateFormat('yyyy-MM-dd').format(date);

      var response = await http.post(myUrl, body: {
        'date': formattedDate,
        'score': score.toString(),
        'employe_id': employeId.toString(),
      });

      if (response.statusCode == 200) {
        print("Performance ajoutée avec succès");
      } else {
        print('Échec de l\'ajout de la performance: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout de la performance: $e');
    }
  }
}
