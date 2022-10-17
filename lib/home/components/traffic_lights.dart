import 'package:flutter/material.dart';
import 'package:semaforo_inteligente/models/traffic_model.dart';

Widget trafficLight(Enum state) {
  return Container(
    padding: const EdgeInsets.all(15),
    color: Colors.black,
    child: Column(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: state == TrafficEnum.red ? 1 : 0.2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.red,
            ),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            height: 150,
            width: 150,
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: state == TrafficEnum.yellow ? 1 : 0.2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.yellow,
            ),
            margin: const EdgeInsets.only(bottom: 10),
            height: 150,
            width: 150,
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: state == TrafficEnum.green ? 1 : 0.2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.green,
            ),
            height: 150,
            width: 150,
          ),
        )
      ],
    ),
  );
}
