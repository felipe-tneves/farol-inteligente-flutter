import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semaforo_inteligente/home/components/drawer.dart';
import 'package:semaforo_inteligente/home/components/traffic_lights.dart';
import 'package:semaforo_inteligente/home/scripts.dart';
import 'package:semaforo_inteligente/models/traffic_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TrafficLights lightStates = TrafficLights();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          InkWell(
            onTap: () => setState(() {
              toggleState(lightStates);
            }),
            child: const Icon(
              Icons.refresh_rounded,
              size: 50,
            ),
          ),
        ],
      ),
      drawer: drawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                trafficLight(lightStates.signalOneState),
                trafficLight(lightStates.signalTwoState),
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
