import 'package:flutter/material.dart';
import 'package:semaforo_inteligente/traffic_lights.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Simulador Semáforo Inteligente'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _trafficLight1 = false;
  bool _trafficLight2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          InkWell(
            onTap: () => setState(() {
              _trafficLight1 = _trafficLight1 ? false : true;
              _trafficLight2 = _trafficLight2 ? false : true;
            }),
            child: const Icon(
              Icons.refresh_rounded,
              size: 50,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(children: []),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                semaforo1(_trafficLight1),
                semaforo2(_trafficLight2),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => toggleModal(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future toggleModal(context) {
  return showModalBottomSheet(context: context, builder: ((context) => Column()));
}
