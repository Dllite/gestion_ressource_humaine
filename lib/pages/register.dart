
import 'package:bloodd/components/page_title_bar.dart';
import 'package:bloodd/components/under_part.dart';
import 'package:bloodd/components/upside.dart';
import 'package:bloodd/pages/login.dart';
import 'package:bloodd/widget/widget.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var username = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
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
              const Upside(
                imgUrl: 'assets/images/Mobile-login-Cristina.jpg',
              ),
              const PageTitleBar(title: 'Créer un nouveau compte'),
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
                      iconButton(context),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Ou remplissez le formulaire",
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
                              controller: username,
                              hinText: "Nom d'utilisateur",
                              icon: Icons.person,
                            ),
                            RoundedInputField(
                              controller: email,
                              hinText: "Email",
                              icon: Icons.email,
                            ),
                            //  RoundedPasswordField(),
                            RoundedInputField(
                              controller: phone,
                              hinText: "Téléphone",
                              icon: Icons.phone,
                            ),
                            RoundedButton(
                                text: 'Créer un compte', press: () {}),
                            const SizedBox(
                              height: 10,
                            ),
                            UnderPart(
                              title: "Vous avez deja un compte ?",
                              navigatorText: "Connexion",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => Login()),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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

  iconButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        RoundedIcon(imageUrl: 'assets/images/facebook.jpg'),
        SizedBox(
          width: 20,
        ),
        RoundedIcon(imageUrl: 'assets/images/google.png'),
      ],
    );
  }
}
