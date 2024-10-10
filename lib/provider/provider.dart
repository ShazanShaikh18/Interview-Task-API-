import 'package:flutter/foundation.dart';
import 'package:task/api/api_service.dart';

import '../model/user_model.dart';

class PostProvider with ChangeNotifier {
  ProductsModel? _products;
  bool _isLoading = false;

  ProductsModel? get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await ApiService().fetchProducts();
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}