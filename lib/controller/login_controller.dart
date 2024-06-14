import 'dart:convert';

import 'package:bloodd/widget/menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  // Contrôleurs pour les champs de saisie
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable observables pour gérer l'état de connexion
  var isLoggedIn = false.obs;

  // Méthode pour effectuer la connexion
  Future<String> loginUser() async {
    try {
      var myUrl = Uri.https('gestion.magiksolve.com', '/connexion.php');
      Map body = {
        "email": emailController.text,
        "mot_de_passe": passwordController.text,
      };
      var response = await http.post(myUrl,
          headers: {'Accept': 'application/json'}, body: body);

      print(response.body);
      if (response.statusCode == 200) {
        final data= jsonDecode(response.body);
        if (data['status'] == 'success') {
          isLoggedIn.value = true;
          String user = data['email'];
          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', user);
          print(data);
          print(user);

          return 'Success'; // Retourne "Success" si la connexion réussit
        } else {
          return 'Error'; // Retourne "Error" si la connexion échoue
        }
      } else {
        throw Exception(
            response.body); // Lance une exception en cas d'erreur HTTP
      }
    } catch (e) {
      print("Une erreur s'est produite : $e");
      print("Type de l'exception : ${e.runtimeType}");

      return 'Error'; // Retourne "Error" en cas d'erreur
    }
  }
Future<void> logoutUser() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id'); // Supprime l'identifiant de l'utilisateur
      isLoggedIn.value = false; // Réinitialise l'état de connexion
      print("Déconnexion réussie");
    } catch (e) {
      print("Une erreur s'est produite lors de la déconnexion : $e");
    }
  }
  @override
  void dispose() {
    // Nettoyage des contrôleurs lorsque le contrôleur est détruit
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
