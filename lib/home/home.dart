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
  @override
  void initState() {
    getAllResult();
  }

  //Variables
  TrafficLights lightStates = TrafficLights();
  bool isLoading = false;
  bool isSimulating = false;
  bool hasData = false;
  FilePickerResult? resultX;
  FilePickerResult? resultY;
  List<InfoModel> allResults = [];
  int vehiclesRua1 = 0;
  int vehiclesRua2 = 0;
  int timer1 = 0;
  int timer2 = 0;
  int timerYellow = 3;
  IndexEnum index = IndexEnum.equal;
  String bias = "";
  late InfoModel infoRuaX;
  late InfoModel infoRuaY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
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
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                InkWell(
                  onTap: () => appWindow.minimize(),
                  child: const Icon(
                    Icons.minimize_rounded,
                    size: 25,
                  ),
                ),
                InkWell(
                  onTap: () => appWindow.close(),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 25,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      drawer: drawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              bias,
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      width: 180,
                      height: 30,
                      child: const Center(child: Text("RUA 1", style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    trafficLight(lightStates.signalOneState),
                    Container(
                      color: Colors.transparent,
                      width: 180,
                      height: 30,
                      child: Center(child: Text("$timer1 segundos", style: const TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ],
                ),
                isSimulating
                    ? InkWell(
                        onTap: () => pauseSimulation(),
                        child: const Icon(
                          Icons.pause,
                          size: 72,
                          color: Colors.white,
                        ),
                      )
                    : InkWell(
                        onTap: () => simulate(),
                        child: const Icon(
                          Icons.play_circle_outline_rounded,
                          size: 72,
                          color: Colors.white,
                        ),
                      ),
                Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      width: 180,
                      height: 30,
                      child: const Center(child: Text("RUA 2", style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    trafficLight(lightStates.signalTwoState),
                    Container(
                      color: Colors.transparent,
                      width: 180,
                      height: 30,
                      child: Center(child: Text("$timer2 segundos", style: const TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ],
                ),
              ],
            ),
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
            const Text("Insira uma foto para cada rua", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        child: Column(children: [
          AppBar(
            toolbarHeight: 50,
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("RUA 1", style: TextStyle(fontSize: 20)),
                Text("RUA 2", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 500,
                child: ListView.builder(
                  itemCount: allResults.length,
                  itemBuilder: (context, index) {
                    if (allResults[index].endereco == "rua1") {
                      return InkWell(
                        onTap: () {
                          showDetails(allResults[index].clima);
                        },
                        child: ListTile(
                          leading: Text("${allResults[index].hora}"),
                          title: const Text("Veículos:"),
                          subtitle: Text("${allResults[index].qtd}"),
                          trailing: Icon(Icons.sunny_snowing),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 500,
                child: ListView.builder(
                  itemCount: allResults.length,
                  itemBuilder: (context, index) {
                    if (allResults[index].endereco == "rua2") {
                      return InkWell(
                        onTap: () {
                          showDetails(allResults[index].clima);
                        },
                        child: ListTile(
                          leading: Text("${allResults[index].hora}"),
                          title: const Text("Veículos:"),
                          subtitle: Text("${allResults[index].qtd}"),
                          trailing: Icon(Icons.sunny_snowing),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("Total de veículos circulados na rua 1:"),
                  Text("$vehiclesRua1"),
                ],
              ),
              Column(
                children: [
                  Text("Total de veículos circulados na rua 2:"),
                  Text("$vehiclesRua2"),
                ],
              ),
            ],
          ),
          Spacer(),
        ]),
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

        await getAllResult();

        resultX = null;
        resultY = null;

        isLoading = false;
        hasData = true;
        setState(() {});
      } catch (e) {
        print(e);
        resultX = null;
        resultY = null;
        isLoading = false;
        hasData = false;
      }
    }
  }

  getAllResult() async {
    var results = await http.get(Uri.parse("http://127.0.0.1:8000/transito"));

    for (var item in jsonDecode(results.body)) {
      allResults.add(InfoModel.fromJson(item));
    }

    for (var item in allResults) {
      if (item.endereco == "rua1") {
        vehiclesRua1 = vehiclesRua1 + item.qtd!.toInt();
      }
      if (item.endereco == "rua2") {
        vehiclesRua2 = vehiclesRua2 + item.qtd!.toInt();
      }
    }
    setState(() {});
  }

  simulate() async {
    if (hasData) {
      isSimulating = true;
      var x = infoRuaX.qtd;
      var y = infoRuaY.qtd;
      index = trafficIndex(x!, y!);
      switch (index) {
        case IndexEnum.equal:
          bias = "Tráfego similar";
          timer1 = 15;
          timer2 = 15;
          break;
        case IndexEnum.minorXBias:
          bias = "Rua 1 com tráfego levemente maior, preferência de sinal pequena para rua 1.";
          timer1 = 15;
          timer2 = 12;
          break;
        case IndexEnum.minorYBias:
          bias = "Rua 2 com tráfego levemente maior, preferência de sinal pequena para rua 1.";
          timer1 = 12;
          timer2 = 15;
          break;
        case IndexEnum.moderateXBias:
          bias = "Rua 1 com tráfego moderadamente maior, preferência de sinal média para rua 1.";
          timer1 = 15;
          timer2 = 10;
          break;
        case IndexEnum.moderateYBias:
          bias = "Rua 2 com tráfego moderadamente maior, preferência de sinal média para rua 2.";
          timer1 = 10;
          timer2 = 15;
          break;
        case IndexEnum.highXBias:
          bias = "Rua 1 com tráfego consideravelmente maior, preferência de sinal alta para rua 1.";
          timer1 = 15;
          timer2 = 8;
          break;
        case IndexEnum.highYBias:
          bias = "Rua 2 com tráfego consideravelmente maior, preferência de sinal alta para rua 2.";
          timer1 = 8;
          timer2 = 15;
          break;
        case IndexEnum.extremeXBias:
          bias = "Rua 1 com tráfego muito maior, preferência de sinal extrema para rua 1.";
          timer1 = 15;
          timer2 = 6;
          break;
        case IndexEnum.extremeYBias:
          bias = "Rua 2 com tráfego muito maior, preferência de sinal extrema para rua 2.";
          timer1 = 6;
          timer2 = 15;
          break;
      }
      playSimulation();
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Nenhum dado para simular"),
            content: Text("Adicione imagens para cada um dos faróis para iniciar a simulação."),
          );
        },
      );
    }
  }

  pauseSimulation() {
    isSimulating = false;
    lightStates.signalOneState = TrafficEnum.yellow;
    lightStates.signalTwoState = TrafficEnum.yellow;
    setState(() {});
  }

  playSimulation() async {
    lightStates.signalOneState = TrafficEnum.yellow;
    lightStates.signalTwoState = TrafficEnum.yellow;
    await Future.delayed(Duration(seconds: 3));
    while (isSimulating) {
      await oneIsGreen();
      await oneIsYellow();
      await twoIsGreen();
      await twoIsYellow();
    }
  }

  showDetails(info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Informações de clima"),
          content: Text("$info"),
        );
      },
    );
  }

  oneIsGreen() async {
    if (isSimulating) {
      setState(() {
        lightStates.signalOneState = TrafficEnum.green;
        lightStates.signalTwoState = TrafficEnum.red;
      });
    }
    await Future.delayed(Duration(seconds: timer1));
  }

  oneIsYellow() async {
    if (isSimulating) {
      setState(() {
        lightStates.signalOneState = TrafficEnum.yellow;
        lightStates.signalTwoState = TrafficEnum.red;
      });
    }
    await Future.delayed(Duration(seconds: timerYellow));
  }

  twoIsGreen() async {
    if (isSimulating) {
      setState(() {
        lightStates.signalOneState = TrafficEnum.red;
        lightStates.signalTwoState = TrafficEnum.green;
      });
    }
    await Future.delayed(Duration(seconds: timer2));
  }

  twoIsYellow() async {
    if (isSimulating) {
      setState(() {
        lightStates.signalOneState = TrafficEnum.red;
        lightStates.signalTwoState = TrafficEnum.yellow;
      });
    }
    await Future.delayed(Duration(seconds: timerYellow));
  }
}
