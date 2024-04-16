import '../Model/user.dart';
import '../Utils/database_helper.dart';

class UserRepository {
  final dbHelper = DatabaseHelper();

  Future<void> addUser(User user) async {
    await dbHelper.insertUser(user);
  }

  Future<User?> getUser(String username, String password) async {
    return await dbHelper.getUser(username, password);
  }
}
