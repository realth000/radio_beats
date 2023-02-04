import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      );
}

class Wapper {
  final countProvider = StateProvider((ref) => 0);
}

final globalProvider = StateProvider((ref) => "asd");

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final countProvider = StateProvider((ref) => 0);
  final w = Wapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('AAAA rebuild!');

    return Scaffold(
      appBar: AppBar(
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer(
              builder: (context, ref, _) => Text(
                '${ref.watch(countProvider)}, ${ref.watch(w.countProvider)}, ${ref.watch(globalProvider)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(countProvider.notifier).state++;
          ref.read(w.countProvider.notifier).state--;
          ref.read(globalProvider.notifier).state += "a";
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
