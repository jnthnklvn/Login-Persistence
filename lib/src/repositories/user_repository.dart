import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:login_persistence/src/models/user_model.dart';

class UserRepository extends Disposable {
  final String api = "https://reqres.in/api";

  Future<String> login(UserModel user) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(
      '$api/login/',
      body: json.encode(user),
      headers: headers,
    );
    print(response.body);
    return response.body;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
