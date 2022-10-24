import 'dart:convert';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:semaforo_inteligente/home/index.dart';
import 'package:semaforo_inteligente/models/index_enum.dart';
import 'package:semaforo_inteligente/models/info_model.dart';
import 'package:semaforo_inteligente/models/traffic_enum.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Variables
  TrafficLights lightStates = TrafficLights();
  bool isLoading = false;
  bool isSimulating = false;
  bool hasData = false;
  FilePickerResult? resultX;
  FilePickerResult? resultY;
  int swapTimer = 10;
  int yellowTimer = 3;
  late InfoModel infoRuaX;
  late InfoModel infoRuaY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.blue,
        title: Center(
          child: WindowTitleBarBox(
            child: MoveWindow(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Simulador Semáforo Inteligente",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () => appWindow.minimize(),
            child: const Icon(
              Icons.minimize_rounded,
            ),
          ),
          InkWell(
            onTap: () => appWindow.close(),
            child: const Icon(
              Icons.close_rounded,
            ),
          )
        ],
      ),
      drawer: drawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                trafficLight(lightStates.signalOneState),
                isSimulating
                    ? InkWell(
                        onTap: () => pause(),
                        child: const Icon(
                          Icons.pause,
                          size: 72,
                          color: Colors.blue,
                        ),
                      )
                    : InkWell(
                        onTap: () => simulate(),
                        child: const Icon(
                          Icons.play_circle_outline_rounded,
                          size: 72,
                          color: Colors.blue,
                        ),
                      ),
                trafficLight(lightStates.signalTwoState),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => toggleModal(context),
        tooltip: 'Increment',
        child: const Icon(Icons.camera_alt_rounded),
      ),
    );
  }

  //Widgets
  Widget bottomSheet(StateSetter setState) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Insira uma foto em cada rua", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    await uploadImage("rua1");
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.roundabout_right,
                          color: resultX != null ? Colors.blue : Colors.white,
                          size: 128,
                        ),
                        const Text("Rua 1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await uploadImage("rua2");
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.roundabout_left,
                          color: resultY != null ? Colors.blue : Colors.white,
                          size: 128,
                        ),
                        const Text("Rua 2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: resultX != null && resultY != null ? 1 : 0.2,
              duration: const Duration(milliseconds: 300),
              child: Material(
                color: Colors.blue,
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: InkWell(
                    onTap: () async {
                      await sendImages(setState);
                      Navigator.pop(context);
                    },
                    child: const Center(
                      child: Text(
                        "PROCESSAR IMAGENS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: LinearProgressIndicator(
            color: Colors.blue,
            value: isLoading ? null : 0,
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Future toggleModal(context) {
    return showModalBottomSheet(
      context: context,
      builder: ((context) {
        return StatefulBuilder(builder: (
          BuildContext context,
          StateSetter setState,
        ) {
          return bottomSheet(setState);
        });
      }),
    );
  }

  Widget drawer() {
    return SizedBox(
      width: 500,
      child: Drawer(
        child: Column(children: []),
      ),
    );
  }

  Widget trafficLight(Enum signalState) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.black,
      child: Column(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: signalState == TrafficEnum.red ? 1 : 0.2,
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
            opacity: signalState == TrafficEnum.yellow ? 1 : 0.2,
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
            opacity: signalState == TrafficEnum.green ? 1 : 0.2,
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

  //Functions
  uploadImage(String road) async {
    if (road == "rua1") {
      resultX = await FilePicker.platform.pickFiles();
    } else {
      resultY = await FilePicker.platform.pickFiles();
    }
  }

  sendImages(setState) async {
    if (resultX != null && resultY != null) {
      try {
        isLoading = true;
        hasData = false;
        setState(() {});
        File file1 = File(resultX!.files.single.path!);
        File file2 = File(resultY!.files.single.path!);

        http.MultipartRequest request1 = http.MultipartRequest('POST', Uri.parse("http://127.0.0.1:8000/arquivos"));
        http.MultipartRequest request2 = http.MultipartRequest('POST', Uri.parse("http://127.0.0.1:8000/arquivos"));
        request1.files.add(await http.MultipartFile.fromPath('meuArquivo', file1.path));
        request2.files.add(await http.MultipartFile.fromPath('meuArquivo', file2.path));
        request1.fields["rua"] = "rua1";
        request2.fields["rua"] = "rua2";

        List<Future> sendRequests = [
          request1.send(),
          request2.send(),
        ];
        await Future.wait(sendRequests);

        http.Response responseRua1;
        http.Response responseRua2;

        responseRua1 = await http.get(Uri.parse("http://127.0.0.1:8000/transito/rua1"));
        responseRua2 = await http.get(Uri.parse("http://127.0.0.1:8000/transito/rua2"));

        infoRuaX = InfoModel.fromJson(jsonDecode(responseRua1.body));
        infoRuaY = InfoModel.fromJson(jsonDecode(responseRua2.body));

        resultX = null;
        resultY = null;

        isLoading = false;
        hasData = true;
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  simulate() async {
    if (hasData) {
      isSimulating = true;
      var x = infoRuaX.qtd;
      var y = infoRuaY.qtd;
      equalPattern();
      // IndexEnum index = trafficIndex(x!, y!);
      // switch (index) {
      //   case IndexEnum.equal:
      //     await equalPattern();
      //     break;
      //   default:
      //     return;
      // }
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("asd"),
            content: Text("asdasd"),
          );
        },
      );
    }
  }

  pause() {
    isSimulating = false;
    lightStates.signalOneState = TrafficEnum.yellow;
    lightStates.signalTwoState = TrafficEnum.yellow;
    setState(() {});
  }

  equalPattern() async {
    while (isSimulating) {
      lightStates.signalOneState = TrafficEnum.green;
      lightStates.signalTwoState = TrafficEnum.red;
      setState(() {});
      await Future.delayed(Duration(seconds: swapTimer));
      lightStates.signalOneState = TrafficEnum.yellow;
      setState(() {});
      await Future.delayed(Duration(seconds: yellowTimer));
      lightStates.signalOneState = TrafficEnum.red;
      lightStates.signalTwoState = TrafficEnum.green;
      setState(() {});
      await Future.delayed(Duration(seconds: swapTimer));
      lightStates.signalTwoState = TrafficEnum.yellow;
      setState(() {});
      await Future.delayed(Duration(seconds: yellowTimer));
    }
    lightStates.signalOneState = TrafficEnum.yellow;
    lightStates.signalTwoState = TrafficEnum.yellow;
  }
}
