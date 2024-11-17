import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


String idColumn = "idColumn";
String dateColumn = "dateColumn";
String titleColumn = "titleColumn";
String descriptionColumn = "descriptionColumn";
String localizationColumn = "localizationColumn";
String imgColumn = "imgColumn";
String diaryTable = "diaryTable";

class TravelDiaryHelper {
  static final TravelDiaryHelper _instance = TravelDiaryHelper.internal();
  factory TravelDiaryHelper() => _instance;
  TravelDiaryHelper.internal();

  Database _db;

  Future<Database> get db async{
    if (_db != null) {
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'traveldiarynew.db');
    return await openDatabase(path, version: 2, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $diaryTable($idColumn INTEGER PRIMARY KEY, $dateColumn TEXT, $titleColumn TEXT, $descriptionColumn TEXT, $localizationColumn TEXT, $imgColumn TEXT)");
    });
  }
  
  Future<List> getAllTravelDiaryEntries() async{
    Database dbEntry = await db;
    List listMap =await dbEntry.rawQuery("SELECT * FROM $diaryTable");
    List<TravelDiaryEntry> listTravelDiaryEntry = List();
    for(Map m in listMap){
      listTravelDiaryEntry.add(TravelDiaryEntry.fromMap(m));
    }
    print(listTravelDiaryEntry);
    return listTravelDiaryEntry;
  }

  Future<TravelDiaryEntry> saveTravelDiaryEntry (TravelDiaryEntry entry) async{
    Database dbEntry = await db;
    entry.id = await dbEntry.insert(diaryTable, entry.toMap());
    return entry;
  }

  Future<TravelDiaryEntry> getTravelDiaryEntry(int id) async{
    Database dbEntry = await db;
    List<Map> maps = await dbEntry.query(diaryTable, columns: [idColumn, dateColumn, titleColumn, descriptionColumn, localizationColumn, imgColumn], where: "$idColumn = ?", whereArgs: [id]);
    if(maps.isNotEmpty){
      return TravelDiaryEntry.fromMap(maps.first);
    }else{
      return null;
    }
  }


  Future<int> deleteTravelDiaryEntry(int id) async{
    Database dbEntry = await db;
    return await dbEntry.delete(diaryTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateTravelDiaryEntry(TravelDiaryEntry entry) async{
    Database dbEntry = await db;
    return await dbEntry.update(diaryTable, entry.toMap(), where: "$idColumn = ?", whereArgs: [entry.id]);
  }
}

class TravelDiaryEntry {
  int id;
  String title;
  String description;
  String localization;
  String img;
  String date; // O formato da data pode ser ajustado conforme necessário.

  TravelDiaryEntry();

  TravelDiaryEntry.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    date = map[dateColumn];
    title = map[titleColumn];
    description = map[descriptionColumn];
    localization = map[localizationColumn];
    img = map[imgColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      dateColumn: date,
      titleColumn: title,
      descriptionColumn: description,
      localizationColumn: localization,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "TravelDiaryEntry(id: $id,  date: $date, title: $title, description: $description, localization: $localization, img: $img)";
  }
}