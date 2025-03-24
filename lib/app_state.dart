import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppState with ChangeNotifier {
  Map<String, dynamic>? _currentUser;
  List<dynamic> _posts = [];
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get currentUser => _currentUser;
  List<dynamic> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Login
  Future<void> login(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'));
      if (response.statusCode == 200) {
        _currentUser = json.decode(response.body);
        await fetchPosts();
      }
    }  finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch posts
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        _posts = json.decode(response.body);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create post
  Future<void> createPost(String title, String body) async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        body: json.encode({
          'title': title,
          'body': body,
          'userId': _currentUser!['id'],
        }),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 201) {
        await fetchPosts();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // edit post
  Future<void> updatePost(int postId, String title, String body) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'),
        body: json.encode({
          'id': postId,
          'title': title,
          'body': body,
          'userId': _currentUser!['id'],
        }),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        await fetchPosts();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete post
  Future<void> deletePost(int postId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
      if (response.statusCode == 200) {
        await fetchPosts();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _posts = [];
    notifyListeners();
  }
}
