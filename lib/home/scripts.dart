import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:semaforo_inteligente/home/components/bottom_sheet.dart';
import 'package:semaforo_inteligente/models/traffic_model.dart';
import 'package:http/http.dart' as http;

Future toggleModal(context) {
  return showModalBottomSheet(context: context, builder: ((context) => bottomSheet()));
}

toggleState(TrafficLights trafficLights) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    Uint8List image = await file.readAsBytes();
    // final Map<String, dynamic> payload = {
    //   "meuArquivo": image.toString(),
    //   "rua": "teste",
    // };
    // var response = await http.post(Uri.parse('http://127.0.0.1:8000/arquivos'), body: payload);
    // print(response);
  } else {
    // User canceled the picker
  }
  trafficLights.signalOneState = TrafficEnum.red;
  trafficLights.signalTwoState = TrafficEnum.yellow;
}
