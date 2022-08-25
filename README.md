1. Create `./pigeons/message.dart`

```dart
import 'package:pigeon/pigeon.dart';

class Message {
  final String subject;
  final String body;
  final String email;

  Message(this.subject, this.body, this.email);
}

@HostApi()
abstract class MessageApi {
  List<Message> getMessages(String email);
}
```

2. Run command

```shell
flutter pub run pigeon \
--input pigeons/message.dart \
--dart_out lib/pigeon.dart \
--objc_header_out ios/Runner/pigeon.h \
--objc_source_out ios/Runner/pigeon.m \
--experimental_swift_out ios/Runner/Pigeon.swift \
--java_out ./android/app/src/main/kotlin/com/example/reproduce_issues_pigeon/Pigeon.java \
--java_package "com.example.reproduce_issues_pigeon"
```

3. Create sample test code (Android only)

- Create `FakeMessageApiData.kt` in `./android/app/src/main/kotlin/com/example/reproduce_issues_pigeon/`

```kotlin
package com.example.reproduce_issues_pigeon

class FakeMessageApiData : Pigeon.MessageApi {

    private val messages = listOf(
        Pigeon.Message.Builder().setSubject("Subject 1").setBody("Hello 1")
            .setEmail("people1@gmail.com").build(),
        Pigeon.Message.Builder().setSubject("Subject 2").setBody("Helle 2")
            .setEmail("people2@gmail.com").build(),
        Pigeon.Message.Builder().setSubject("Subject 3").setBody("Hello 3")
            .setEmail("people3@gmail.com").build(),
    )

    override fun getMessages(email: String): MutableList<Pigeon.Message> {
        return messages.filter {
            it.email.contains(email)
        }.toMutableList()
    }
}
```

- On `MainActivity.kt`:

```kotlin
package com.example.reproduce_issues_pigeon

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Pigeon.MessageApi.setup(flutterEngine.dartExecutor.binaryMessenger, FakeMessageApiData())
    }

}
```

- On `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:reproduce_issues_pigeon/pigeon.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  List<Message?> myMessage = [];

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: myMessage.length,
          itemBuilder: (_, int index) => buildItemMessage(myMessage[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getMessageFromPigeon,
        child: const Icon(Icons.download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  buildItemMessage(Message? message) => Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(message?.email ?? ''),
          Text(message?.subject ?? ''),
          Text(message?.body ?? ''),
        ],
      ));

  void _getMessageFromPigeon() async {
    final retrieved = await MessageApi().getMessages('people');
    setState(() {
      myMessage = retrieved;
    });
  }
}
```

Result:

<img width="551" alt="Screenshot 2022-08-25 at 17 00 02" src="https://user-images.githubusercontent.com/104349824/186635889-2e8ad887-6f5c-4d90-8032-1847b7e6efda.png">
