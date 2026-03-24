import 'dart:convert';
import 'package:http/http.dart' as http;

class RecallService {
  static final RecallService _instance = RecallService._internal();
  factory RecallService() => _instance;
  RecallService._internal();

  static const String _baseUrl =
      'https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso0/records';

  Future<Map<String, dynamic>?> getRecallByBarcode(String barcode) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'where': 'code_barres="$barcode"',
      'limit': '1',
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>?;
      if (results != null && results.isNotEmpty) {
        return results.first as Map<String, dynamic>;
      }
    }
    return null;
  }
}
