import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  static String get pocketBaseUrl {
    // L'adresse IP locale de ton PC sur ton réseau Wi-Fi
    return 'http://10.62.39.204:8090'; 
  }

  static const String openFoodFactsBaseUrl = 'https://api.formation-flutter.fr/v2';
  static const String rappelConsoBaseUrl = 'https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso0/records';
}
