import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/user_model.dart';

class ApiService {
  final String baseUrl = 'http://api.mystorestory.com/api/MenuMaster/GetPoskotForShop?shop_id=4591';

  Future<ProductsModel> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      return ProductsModel.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }
}