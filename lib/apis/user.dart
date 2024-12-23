import 'dart:convert';

import 'package:mobile_store/apis/base.dart';
import 'package:mobile_store/utils/exception/token_has_expired_exception.dart';
import 'package:mobile_store/utils/method/my_method.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserAPI{
  static const String allUsers = '${BaseAPI.api}/users';
  static const String login = '$allUsers/login';
  static const String register = '$allUsers/register';

  static Future<User> getUserByToken(String token) async {
    final baseUrl = Uri.parse('$allUsers/auth/me');
    final response = await http.get(baseUrl, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes)); //  khắc phục lỗi phông chữ tiếng việt

      if (MyMethod.isTokenHasExpired(map)){
        throw const TokenHasExpiredException();
      }

      return User.fromMap(map);
    }
    throw Exception('Failed to get user by id: ${response.statusCode}');
  }
}