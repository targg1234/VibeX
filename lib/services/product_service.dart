import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'dart:async';

class ProductService {
  static const _baseUrl = 'https://6832fa3cc3f2222a8cb483c3.mockapi.io/status';
  final _headers = {'Content-Type': 'application/json'};

  Future<List<Product>> fetchAllProduct() async {
    final response = await http
        .get(Uri.parse(_baseUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('failed to load products');
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to create products');
  }

  Future<Product> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: _headers,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to update products');
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('failed to delete products');
    }
  }
}
