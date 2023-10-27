import 'package:flutter/material.dart';
import 'package:gym_tracker/theme.dart';
import 'package:provider/provider.dart';
/* import 'package:gym_tracker/theme.dart';
import 'package:provider/provider.dart'; */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FlutterNativeSplash.remove();
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) =>
          ThemeProvider(isDarkMode: prefs.getBool('isDarkTheme') ?? false),
      child: const MyApp(),
    ),
  );
}

class Exercise {
  String name = "";
  String description = "";

  Exercise(this.name, this.description);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.getTheme,
        routes: {
          '/': (context) => const HomePage(),
          '/exercises': (context) => Exercises(),
          '/new-exercise': (context) => const NewExercise(),
        },
      );
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/exercises');
                  },
                  child: const Text(
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    'Ver exercícios',
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    ThemeProvider themeProvider = Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    );

                    themeProvider.swapTheme();
                  },
                  child: const Text(
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    'Alterar tema',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Exercises extends StatefulWidget {
  const Exercises({super.key});

  @override
  ExercisesState createState() => ExercisesState();
}

class ExercisesState extends State<Exercises> {
  List<Exercise> exercises = [];

  Future<void> _navigateAndUpdateState(BuildContext context) async {
    Exercise result =
        await Navigator.pushNamed(context, '/new-exercise') as Exercise;
    setState(() {
      exercises.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                childAspectRatio: (1 / .3),
                shrinkWrap: true,
                children: <Widget>[
                  ...exercises
                      .map(
                        (exercise) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8.0),
                                width: double.infinity,
                                color: Colors.grey[600],
                                child: Text(exercise.name),
                              ),
                              Text(exercise.description),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    _navigateAndUpdateState(context);
                  },
                  child: Text('Novo exercício'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewExercise extends StatefulWidget {
  const NewExercise({super.key});

  @override
  State<StatefulWidget> createState() => _NewExerciseState();
}

class ExerciseData {
  String name = "";
  String description = "";
}

class _NewExerciseState extends State {
  ExerciseData exerciseData = ExerciseData();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o exercício";
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (value == null) return;

                  exerciseData.name = value;
                },
                decoration: const InputDecoration(
                    hintText: "Supino", labelText: "Exercício"),
              ),
              TextFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Informe a descrição o exercício";
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (value == null) return;

                  exerciseData.description = value;
                },
                decoration: const InputDecoration(
                    hintText: "Um exercício para ficar fortinho",
                    labelText: "Descrição"),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (key.currentState!.validate()) {
                      key.currentState!.save();
                      Exercise newExercise =
                          Exercise(exerciseData.name, exerciseData.description);
                      Navigator.pop(context, newExercise);
                    }
                  },
                  child: const Text('Inserir'))
            ],
          ),
        ),
      ),
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

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
