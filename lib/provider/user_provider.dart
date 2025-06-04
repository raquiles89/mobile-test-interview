import 'dart:convert';
import 'package:dat_interview_test/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    final res = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      _users = User.fromJsonList(jsonDecode(res.body));
      await saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('users');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      _users = User.fromJsonList(decoded);
      notifyListeners();
    }
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_users.map((u) => u.toJson()).toList());
    await prefs.setString('users', jsonString);
  }

  void addUser(User user) {
    _users.add(user);
    saveToPrefs();
    notifyListeners();
  }

  void deleteUser(int index) {
    _users.removeAt(index);
    saveToPrefs();
    notifyListeners();
  }
}
