import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'preloader_screen.dart';
import 'dream_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DreamModelAdapter());
  await Hive.openBox<DreamModel>('dreams');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Altabir',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir',
      ),
      home: PreloaderScreen(),
    );
  }
}