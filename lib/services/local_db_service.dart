import 'package:expense_planner_pro/models/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static Database _db;

  static Future<Database> get _getDb async {
    if (_db != null) return _db;
    final dbPath = join(await getDatabasesPath(), TransactionEntity.dbName);
    // await deleteDatabase(dbPath);
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''CREATE TABLE ${TransactionEntity.tableName} (
          ${TransactionEntity.idField} INTEGER PRIMARY KEY autoincrement, 
          ${TransactionEntity.dateTimeField} TEXT, 
          ${TransactionEntity.titleField} TEXT, 
          ${TransactionEntity.amountField} REAL, 
          ${TransactionEntity.isDebitField} INTEGER, 
          ${TransactionEntity.remarkField} TEXT
          )''',
        );
      },
    );
    return _db;
  }

  static Future<List<TransactionEntity>> get getAllTransactions async {
    TransactionEntity.finalBalance = 0;
    return (await (await _getDb).query(TransactionEntity.tableName))
        .map(
          (e) => TransactionEntity.fromMap(e),
        )
        .toList();
  }

  static Future<TransactionEntity> findById(int id) async {
    final res = (await (await _getDb).query(TransactionEntity.tableName, where: '${TransactionEntity.idField} = ?', whereArgs: [id]));
    if (res.length > 0) {
      return TransactionEntity.fromMap(res.first);
    }
    return null;
  }

  static Future<void> insert(TransactionEntity transactionEntity) async => transactionEntity.id = await (await _getDb).insert(
        TransactionEntity.tableName,
        transactionEntity.toMap,
      );

  static Future<void> update(TransactionEntity transactionEntity) async => await (await _getDb).update(
        TransactionEntity.tableName,
        transactionEntity.toMap,
        where: '${TransactionEntity.idField} = ?',
        whereArgs: [transactionEntity.id],
      );

  static Future<void> delete(TransactionEntity transactionEntity) async => await (await _getDb).delete(
        TransactionEntity.tableName,
        where: '${TransactionEntity.idField} = ?',
        whereArgs: [transactionEntity.id],
      );

  static Future closeDb() async {
    await _db?.close();
    _db = null;
  }

  static Future deleteAll() async => await (await _getDb).execute('DELETE FROM ${TransactionEntity.tableName}');
}
