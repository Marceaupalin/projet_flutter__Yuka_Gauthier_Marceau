import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:formation_flutter/core/constants/api_constants.dart';

class PocketBaseService extends ChangeNotifier {
  static final PocketBaseService _instance = PocketBaseService._internal();
  factory PocketBaseService() => _instance;

  late final PocketBase pb;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'pb_auth_token';
  static const String _modelKey = 'pb_auth_model';

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  PocketBaseService._internal() {
    pb = PocketBase(ApiConstants.pocketBaseUrl);
  }

  Future<void> init() async {
    final token = await _storage.read(key: _tokenKey);
    final model = await _storage.read(key: _modelKey);

    if (token != null && model != null) {
      pb.authStore.save(token, null);
      if (pb.authStore.isValid) {
        _isAuthenticated = true;
        try {
          await pb.collection('users').authRefresh();
          _isAuthenticated = true;
        } catch (_) {
          _isAuthenticated = false;
          await _clearAuth();
        }
      }
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final authRecord = await pb.collection('users').authWithPassword(email, password);
    await _saveAuth();
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    await pb.collection('users').create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': password,
    });
    await login(email, password);
  }

  Future<void> logout() async {
    pb.authStore.clear();
    await _clearAuth();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> _saveAuth() async {
    await _storage.write(key: _tokenKey, value: pb.authStore.token);
  }

  Future<void> _clearAuth() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _modelKey);
  }

  String? get userId => pb.authStore.record?.id;

  Future<void> addToHistory(String barcode, String? name, String? brand, String? imageUrl, String? nutriScore) async {
    await pb.collection('history').create(body: {
      'user': userId,
      'barcode': barcode,
      'name': name ?? '',
      'brand': brand ?? '',
      'image_url': imageUrl ?? '',
      'nutri_score': nutriScore ?? '',
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final records = await pb.collection('history').getFullList(
      sort: '-created',
      filter: 'user = "$userId"',
    );
    return records.map((r) => r.toJson()).toList();
  }

  Future<void> addToFavorites(String barcode, String? name, String? brand, String? imageUrl, String? nutriScore) async {
    final existing = await pb.collection('favorites').getFullList(
      filter: 'user = "$userId" && barcode = "$barcode"',
    );
    if (existing.isEmpty) {
      await pb.collection('favorites').create(body: {
        'user': userId,
        'barcode': barcode,
        'name': name ?? '',
        'brand': brand ?? '',
        'image_url': imageUrl ?? '',
        'nutri_score': nutriScore ?? '',
      });
    }
  }

  Future<void> removeFromFavorites(String barcode) async {
    final records = await pb.collection('favorites').getFullList(
      filter: 'user = "$userId" && barcode = "$barcode"',
    );
    for (final record in records) {
      await pb.collection('favorites').delete(record.id);
    }
  }

  Future<bool> isFavorite(String barcode) async {
    final records = await pb.collection('favorites').getFullList(
      filter: 'user = "$userId" && barcode = "$barcode"',
    );
    return records.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final records = await pb.collection('favorites').getFullList(
      sort: '-created',
      filter: 'user = "$userId"',
    );
    return records.map((r) => r.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> getRecalls(String barcode) async {
    final records = await pb.collection('recalls').getFullList(
      filter: 'barcode = "$barcode"',
    );
    return records.map((r) => r.toJson()).toList();
  }
}
