

import 'package:sqflite/sqflite.dart';

import 'database_connection.dart';


class Repository{
  DatabaseConnection _databaseConnection;

  Repository(){
    // initialize database connection
    _databaseConnection = DatabaseConnection();
  }
  
  static Database _database;

  Future<Database> get database async {
    if(_database !=null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  //inserting data to table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //Read data from table
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }
 
  // read data from table by id 
  readDataById(table, itemId) async {
    var connection = await database;
    print(itemId);
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  //update data from table
  updateData(table, data) async {
  var connection = await database;
  return await connection.update(table, data, where: 'id=?', whereArgs: [data['id']]);

  }

  //delete data from table
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete('DELETE FROM $table WHERE id = $itemId');
  }

  //read data from table by column name
  readDataByColumnName(table, columnName, columnValue) async {
    var connection = await database;
    return await connection.query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }

}
