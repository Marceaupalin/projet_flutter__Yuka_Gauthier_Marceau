import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/core/services/pocketbase_service.dart';
import 'package:formation_flutter/model/product.dart';

class ProductFetcher extends ChangeNotifier {
  ProductFetcher({required String barcode})
    : _barcode = barcode,
      _state = ProductFetcherLoading() {
    loadProduct();
  }

  final String _barcode;
  ProductFetcherState _state;

  Future<void> loadProduct() async {
    _state = ProductFetcherLoading();
    notifyListeners();

    try {
      Product product = await OpenFoodFactsAPI().getProduct(_barcode);
      
      Map<String, dynamic>? recallData;
      try {
        final recalls = await PocketBaseService().getRecalls(_barcode);
        if (recalls.isNotEmpty) {
          recallData = recalls.first;
        }
      } catch (_) {}

      _state = ProductFetcherSuccess(product, recallData: recallData);
    } catch (error) {
      _state = ProductFetcherError(error);
    } finally {
      notifyListeners();
    }
  }

  ProductFetcherState get state => _state;
}

sealed class ProductFetcherState {}

class ProductFetcherLoading extends ProductFetcherState {}

class ProductFetcherSuccess extends ProductFetcherState {
  ProductFetcherSuccess(this.product, {this.recallData});

  final Product product;
  final Map<String, dynamic>? recallData;
}

class ProductFetcherError extends ProductFetcherState {
  ProductFetcherError(this.error);

  final dynamic error;
}
