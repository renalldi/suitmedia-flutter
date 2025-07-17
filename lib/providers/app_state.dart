import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class AppState with ChangeNotifier {
  String _userName = '';
  String _selectedUserName = '';
  List<User> _users = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  String get userName => _userName;
  String get selectedUserName => _selectedUserName;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setSelectedUserName(String name) {
    _selectedUserName = name;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }

  void addUsers(List<User> newUsers) {
    _users.addAll(newUsers);
    notifyListeners();
  }

  void incrementPage() {
    _currentPage++;
  }

  void setHasMoreData(bool hasMore) {
    _hasMoreData = hasMore;
  }

  int get currentPage => _currentPage;

  void resetUsers() {
    _users.clear();
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();
  }

  // Fetch users from API
  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (_isLoading) return;

    if (isRefresh) {
      resetUsers();
    }

    setLoading(true);

    try {
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users?page=$_currentPage&per_page=6'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> userData = jsonData['data'];
        final List<User> newUsers = userData.map((json) => User.fromJson(json)).toList();
        
        if (isRefresh) {
          setUsers(newUsers);
        } else {
          addUsers(newUsers);
        }

        // Check if there's more data
        final totalPages = jsonData['total_pages'];
        if (_currentPage >= totalPages) {
          setHasMoreData(false);
        }

        if (!isRefresh) {
          incrementPage();
        }
      }
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      setLoading(false);
    }
  }
}
