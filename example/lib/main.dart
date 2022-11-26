import 'package:flutter/material.dart';
import 'package:flutter_scan_tools/flutter_scan_tools.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CardScanResul? scanResul;

  void _startScan() async {
    await Permission.camera.request();

    final scanResul = await FlutterScanTools.scanCard(context);

    setState(() {
      this.scanResul = scanResul;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Card type: ${scanResul?.cardNumber.type.name ?? ''}',
            ),
            Text(
              'Card number: ${scanResul?.cardNumber.number ?? ''}',
            ),
            Text(
              'Card expiry: ${scanResul?.expiry ?? ''}',
            ),
            Text(
              'Card holder: ${scanResul?.holder ?? ''}',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScan,
        tooltip: 'scan',
        child: const Icon(Icons.camera_alt_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
