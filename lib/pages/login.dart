import 'dart:convert';

import 'package:bloodd/widget/menu_bar.dart';
import 'package:bloodd/widget/rounded_input_field.dart';
import 'package:bloodd/widget/rounded_password_field.dart';
import 'package:device_name/device_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../components/page_title_bar.dart';
import '../components/upside.dart';
import '../controller/login_controller.dart';
import '../widget/rounded_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /*final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();*/

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //loginController.emailController.dispose();
    //loginController.passwordController.dispose();
    super.dispose();
  }

  LoginController loginController = Get.put(LoginController());
  var isLoggedIn = false.obs;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Stack(children: [
              const PageTitleBar(title: 'Connexion'),
              Padding(
                padding: const EdgeInsets.only(top: 320.0),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Remplir le formulaire",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'OpenSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Form(
                        child: Column(
                          children: [
                            RoundedInputField(
                              controller: loginController.emailController,
                              hinText: "Email",
                              icon: Icons.mail,
                            ),
                            RoundedPasswordField(
                              controller: loginController.passwordController,
                            ),
                            switchListTitle(),
                            ElevatedButton(
                              onPressed: () async {
                                String result =
                                    await loginController.loginUser();
                                    print(result);
                                if (result == 'Success') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Connexion réussie'),
                                        content: Text(
                                            'Vous êtes connecté avec succès'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => HomeScreen()),
                                              );
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Erreur de connexion'),
                                        content: Text('Identifiants invalides'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text('Connexion'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  switchListTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 40),
      child: SwitchListTile(
        dense: true,
        title: const Text(
          'Se souvenir de moi',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        value: true,
        activeColor: Colors.blue,
        onChanged: (value) {},
      ),
    );
  }

  /*Future<void> loginUser() async {
    var serverUrl = Uri.https('propharma.cm', '/api');

    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var myUrl = Uri.http('propharma.cm', '/api/auth-blood/login');
      //final deviceId = DeviceName();
      var response = await http.post(myUrl, headers: {
        'Accept': 'application/json'
      },
          // ignore: unnecessary_string_interpolations
          body: {
            // ignore: unnecessary_string_interpolations
            "username": usernameController.text,
            "password": passwordController.text,
            "device_id": "Tecno Spark 3",
          });

      // print("deviced_id");
      status = response.body.contains('error');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        bool isLoggedIn = true;
        token = json['access_token'];
        print(token);

        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('token', token);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Nom d'utilisateur ou mot de passe invalide")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Les champs vides ne sont pas autorisés")));
    }
  }*/
}
