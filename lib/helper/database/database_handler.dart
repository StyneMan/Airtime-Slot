import 'package:data_extra_app/model/transactions/guest_transaction_model.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  String dbName = "transactions_database.db";

  Future<Database> initDB() async {
    return await openDatabase(
      Path.join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE Transactions(id INTEGER PRIMARY KEY, email TEXT, description TEXT, type TEXT, status TEXT, amount TEXT, discount_amount TEXT, transaction_ref TEXT, created_at TEXT, discount_text TEXT, payment_method TEXT, amount_paid TEXT, discount_percent TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveTransaction(GuestTransactionModel trans) async {
    int result = 0;
    final Database db = await initDB();
    final id = await db.insert('Transactions', trans.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<GuestTransactionModel>> transactions() async {
    // Get a reference to the database.
    final db = await initDB();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query('Transactions', orderBy: "created_at");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GuestTransactionModel(
        id: maps[i]['id'],
        type: maps[i]['type'],
        email: maps[i]['email'],
        status: maps[i]['status'],
        amount: maps[i]['amount'],
        createdAt: maps[i]['created_at'],
        description: maps[i]['description'],
        discountText: maps[i]['discount_text'],
        discountAmount: maps[i]['discount_amount'],
        discountPercent: maps[i]['discount_percent'],
        transactionRef: maps[i]['transaction_ref'],
        paymentMethod: maps[i]['payment_method'],
        amountPaid: maps[i]['amount_paid'],
      );
    });
  }

  Future<void> updateTransaction(GuestTransactionModel transactionModel) async {
    // Get a reference to the database.
    final db = await initDB();

    // Update the given Transaction.
    await db.update(
      'Transactions',
      transactionModel.toMap(),
      // Ensure that the Transaction has a matching id.
      where: 'id = ?',
      // Pass the Transaction's id as a whereArg to prevent SQL injection.
      whereArgs: [transactionModel.id],
    );
  }
}
