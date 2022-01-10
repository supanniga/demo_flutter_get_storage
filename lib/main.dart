import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  print('main');
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Get Storage'),
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
  final box = GetStorage();

  Map<String, bool> defaultSettings = {
    'sound enable': false,
    'music enable': false,
    'show notifications': false,
  };

  Map<String, dynamic> settings = {};

  @override
  void initState() {
    print('initState');
    print('box : $box');
    print('box.keys : ${box.getKeys()}');
    print('box.values : ${box.getValues()}');
    print('box.toString() : ${box.toString()}');

    settings = box.read('settings') ?? defaultSettings;

    box.listen(() {
      print('listen');
    });

    box.listenKey('settings', (value) {
      print('listenKey settings : $value');
    });

    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    print('box : $box');
    print('box.keys : ${box.getKeys()}');
    print('box.values : ${box.getValues()}');
    print('box.toString() : ${box.toString()}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              itemCount: settings.length,
              itemBuilder: (BuildContext context, int index) {
                String key = settings.keys.elementAt(index);
                return CheckboxListTile(
                    title: Text(key),
                    value: settings[key],
                    onChanged: (value) {
                      print('onChanged $key $value');
                      setState(() {
                        settings[key] = value;
                      });
                    });
              }),
          ElevatedButton(
            child: const Text('Save Settings'),
            onPressed: () async {
              await box.write('settings', settings);
              setState(() {
                print('saved.');
              });
            },
          ),
          ElevatedButton(
            child: const Text('Clear Settings'),
            onPressed: () async {
              await box.erase();
              setState(() {
                print('cleared.');
              });
            },
          ),
        ],
      )),
    );
  }
}
