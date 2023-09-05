import 'package:fitconnectionkit/ConnectionKit/HealthConnection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import 'ConnectionKit/Watch/ConnectionByBluetooth/constants/shared_prefs_strings.dart';
import 'ConnectionKit/Watch/ConnectionByBluetooth/models/bluetooth_model.dart';
import 'ConnectionKit/Watch/ConnectionByBluetooth/models/home.dart';
import 'ConnectionKit/Watch/ConnectionByBluetooth/pages/device_list.dart';
import 'ConnectionKit/Watch/ConnectionByBluetooth/pages/home.dart';
import 'ConnectionKit/Watch/ConnectionByBluetooth/utils/shared_prefs_utils.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothModel>(create: (_) => BluetoothModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _showPage(BuildContext context) {

    return FutureBuilder(
      future:
      SharedPrefsUtils.getString(SharedPrefsStrings.DEVICE_ID_KEY),
      builder: (context, futureSnapshot) {
        String? deviceId = futureSnapshot.data;
        if (deviceId == null) {
          return const DeviceListPage();
        } else {
          var bluetoothModel = context.read<BluetoothModel>();
          return StreamBuilder(
            stream: bluetoothModel.connect(deviceId),
            builder: (__, streamSnapshot) {
              if (streamSnapshot.hasData) {
                ConnectionStateUpdate? connectionStateUpdate =
                    streamSnapshot.data;
                DeviceConnectionState state =
                    connectionStateUpdate?.connectionState ??
                        DeviceConnectionState.disconnected;
                if (state == DeviceConnectionState.connected) {
                  return ChangeNotifierProvider<HomeModel>(
                    create: (_) => HomeModel(),
                    child: const HomePage(),
                  );
                } else {
                  return const DeviceListPage();
                }
              }
              return const DeviceListPage();
            },
          );
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _showPage(context)/*const MyHomePage(title: 'Flutter Demo Home Page')*/,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RequestPermissionHealth();
  }

  


  void _incrementCounter() {
    setState(() {
      Write_Health().then((value) {
        Steps_Health_Day().then((value) {
          print("steps day = $value");
        });
        HR_Health_Day().then((value) {
          print("HR day = $value");
        });
        Steps_Health_Device_Last( DateTime(DateTime.now().year,
            DateTime.now().month,DateTime.now().day, 0,0,0,0,0),
            DateTime(DateTime.now().year,
                DateTime.now().month,DateTime.now().day, 23,59,59,59,59)).then((value) {
          print("steps device  = $value");
        });
        HR_Health_Device_Last( DateTime(DateTime.now().year,
            DateTime.now().month,DateTime.now().day, 0,0,0,0,0),
            DateTime(DateTime.now().year,
                DateTime.now().month,DateTime.now().day, 23,59,59,59,59)).then((value) {
          print("hr device = $value");
        });
      });



    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
