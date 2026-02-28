import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/book.dart';

class ApiService {
  // استخدم الرابط الصحيح بعد التأكد منه
  static const String baseUrl = 'https://dawn-knobbiest-statistically.ngrok-free.dev/api';

  // للـ local development
  // static const String baseUrl = 'http://10.0.2.2:3000/api'; // للأندرويد إيموليتور
  // static const String baseUrl = 'http://localhost:3000/api'; // للويب

  // تحديث حالة المستخدم
  static Future<bool> updateUserStatus(String userId) async {
    try {
      print('Updating user status for ID: $userId');

      final url = Uri.parse('$baseUrl/User/update-status/$userId');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exception in updateUserStatus: $e');
      return false;
    }
  }

  // تسجيل الدخول
  static Future<User?> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/User/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Login exception: $e');
      return null;
    }
  }

  // تسجيل حساب جديد
  static Future<User?> register(String name, String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/User/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Register exception: $e');
      return null;
    }
  }

  // جلب جميع الكتب
  static Future<List<Book>> fetchBooks() async {
    try {
      final url = Uri.parse('$baseUrl/Books');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Fetch books exception: $e');
      return [];
    }
  }

  // استعارة كتاب
  static Future<bool> checkoutBook(String userId, String bookId) async {
    try {
      final url = Uri.parse('$baseUrl/Books/checkout');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'bookId': bookId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Checkout exception: $e');
      return false;
    }
  }

  // إرجاع كتاب
  static Future<bool> returnBook(String userId, String bookId) async {
    try {
      final url = Uri.parse('$baseUrl/Books/return');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'bookId': bookId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Return exception: $e');
      return false;
    }
  }
}