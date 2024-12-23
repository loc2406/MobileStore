import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/src/response.dart';
import 'package:mobile_store/utils/exception/token_has_expired_exception.dart';

import '../../apis/user.dart';
import '../../models/user.dart';
import '../../utils/sharedref/my_shared_ref.dart';
import 'account_state.dart';
import 'package:http/http.dart' as http;

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountState.initial());

  fetchUser() async {
    try {
      emit(AccountState.loading());
      final token = await MySharedRef.getToken();
      if (token == null || token.isEmpty){
        emit(AccountState.noLoggedIn());
      }else{
        User user = await UserAPI.getUserByToken(token);
        emit(AccountState.success(user));
      }
    } catch (e) {
      if (e is TokenHasExpiredException){
        emit(AccountState.tokenHasExpired());
      }
      else{
        emit(
          AccountState.error(e.toString()),
        );
      }
    }
  }

  void setLogoutState() {
    emit(AccountState.noLoggedIn());
  }

  Future<Response> handleLogin(String username, String password) async {
    final Map<String, dynamic> body = {
      'username': username,
      'password': password,
    };

    return await http.post(Uri.parse(UserAPI.login),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }

  Future<Response> handleRegister(String username, String name, String password) async {
    final body = {
      'name': name,
      'username': username,
      'password': password,
    };

    return await http.post(Uri.parse(UserAPI.register),
        body: jsonEncode(body),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
  }
}
