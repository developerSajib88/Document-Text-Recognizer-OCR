import 'package:hive/hive.dart';

class LocalDatabase {

  final database = Hive.box("database");

  void setScannedData(String? data) async => database.put("data", data);

  String? getScannedData()=> database.get("data");

}