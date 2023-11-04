import 'package:gym_tracker/exercise.dart';
import 'package:gym_tracker/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE exercises(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL,
              description TEXT NOT NULL)''',
        );
      },
      version: 1,
    );
  }

  Future<bool> insertExercise(Exercise exercise) async {
    final Database db = await initializeDB();
    await db.insert('exercises', exercise.toMap());
    return true;
  }

  Future<List<Exercise>> retrieveExercises() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('exercises');
    return queryResult.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<void> deleteExercise(int id) async {
    final db = await initializeDB();
    await db.delete(
      'exercises',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
