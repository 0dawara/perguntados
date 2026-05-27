import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthRepository {
  Future<ParseResponse> login(String username, String password) async {
    final user = ParseUser(username, password, null);
    return await user.login();
  }

  Future<ParseResponse> signUp(String username, String password, String email) async {
    final user = ParseUser(username, password, email)..set('totalScore', 0);
    final acl = ParseACL()..setPublicReadAccess(allowed: true);
    user.setACL(acl);
    return await user.signUp();
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      await user.logout();
    }
  }

  Future<ParseUser?> getCurrentUser() async {
    return await ParseUser.currentUser() as ParseUser?;
  }

  Future<ParseUser?> refreshUser(ParseUser user) async {
    final response = await user.getObject(user.objectId!);
    if (response.success && response.results != null) {
      return response.results!.first as ParseUser;
    }
    return null;
  }
}
