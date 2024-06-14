import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'cubit/theme_cubit.dart';
import 'pages/home_app.dart';
import 'pages/login.dart';
import 'pages/splash_screen.dart';
import 'widget/menu_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Vérifier l'état de connexion
  await Settings.init(cacheProvider: SharePreferenceCache());
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({
    Key? key,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (_) => ThemeCubit(true),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return MaterialApp(
            themeMode: state ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: isLoggedIn ? HomeScreen() : Login(), // Afficher HomeScreen ou LoginScreen selon l'état de connexion
          );
        },
      ),
    );
  }
}
