import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(),'Food_data.db'),

    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE food(food_id INTEGER PRIMARY KEY,food_url TEXT)',
      );
    },
    version: 1,
  );

  Future<void> insertFood(FoodData fooddata) async{
    final db = await database;

    await db.insert('food',
     fooddata.toMap(),
     conflictAlgorithm: ConflictAlgorithm.replace,
     );
   }
  
  Future<List<FoodData>> fooddata() async{
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('food');

    return List.generate(maps.length, (i){
      return FoodData(
        food_id: maps[i]['food_id'],
        food_url: maps[i]['food_url']);

    });
  }

  Future<void> updateFood(FoodData food) async{
    final db = await database;

    await db.update(
      'food',
      food.toMap(),
      where: 'food_id=?',
      whereArgs: [food.food_id],
      );
  }

  Future<void> deleteFood(int food_id) async{
    final db = await database;

    await db.delete(
      'food',
      where: 'food_id=?',
      whereArgs: [food_id],
      
    );
  }

  

}

class FoodData{
  final int food_id;
  final String food_url;

  const FoodData({
    required this.food_id,
    required this.food_url,
  });

  Map<String,dynamic> toMap(){
    return{
      'food_id' : food_id,
      'food_url' : food_url,
    };
  }

  @override
  String toString(){
    return 'Food_data{food_id:$food_id,food_url:$food_url}';
  }
}