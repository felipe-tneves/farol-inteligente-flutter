import 'package:flutter/material.dart';

Widget semaforo1(_trafficLight1) {
  return Column(
    children: [
      const Text(
        "Semáforo 1",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: _trafficLight1 ? Colors.red : Color.fromARGB(255, 31, 9, 7),
        ),
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        height: 200,
        width: 200,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: _trafficLight1 ? Color.fromARGB(255, 13, 29, 13) : Colors.green,
        ),
        height: 200,
        width: 200,
      )
    ],
  );
}

Widget semaforo2(_trafficLight2) {
  return Column(
    children: [
      const Text(
        "Semáforo 2",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: _trafficLight2 ? Colors.red : Color.fromARGB(255, 31, 9, 7),
        ),
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        height: 200,
        width: 200,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: _trafficLight2 ? Color.fromARGB(255, 13, 29, 13) : Colors.green,
        ),
        height: 200,
        width: 200,
      )
    ],
  );
}