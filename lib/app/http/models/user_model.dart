import 'package:mongo_dart/mongo_dart.dart';

class UserModel {
  final String? id;
  final String username;
  final String password;

  UserModel({this.id, required this.username, required this.password});

  // Save user to database
  Future<void> save() async {
    final db = await Db.create('mongodb://localhost:27017/vania_api');
    await db.open();
    final collection = db.collection('users');

    await collection.insert({
      'username': username,
      'password': password,
    });

    await db.close();
  }

  // Find user by username
  static Future<UserModel?> findByUsername(String username) async {
    final db = await Db.create('mongodb://localhost:27017/vania_api');
    await db.open();
    final collection = db.collection('users');

    final user = await collection.findOne({'username': username});
    await db.close();

    if (user == null) return null;
    return UserModel(
      id: user['_id'].toString(),
      username: user['username'],
      password: user['password'],
    );
  }
}
