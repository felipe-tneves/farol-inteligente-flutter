import 'dart:io';

import 'package:flutter/material.dart';
import 'package:semaforo_inteligente/home/home.dart';
import 'package:semaforo_inteligente/home/components/traffic_lights.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Semáforo Inteligente');
    setWindowMaxSize(const Size(1280, 720));
    setWindowMinSize(const Size(1280, 720));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semáforo Inteligente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(title: 'Simulador Semáforo Inteligente'),
    );
  }
}
