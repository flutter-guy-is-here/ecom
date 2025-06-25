import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Product.dart';
import '../models/category.dart';

class ApiService {
  static const baseUrl = 'https://api.escuelajs.co/api/v1';

  static Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/categories'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((cat) => Category.fromJson(cat)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<MyProduct>> fetchProducts(String? category) async {
    final url = (category != null && category.isNotEmpty)
        ? '$baseUrl/products/?category.name=$category'
        : '$baseUrl/products';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((json) => MyProduct.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<MyProduct> fetchProductById(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (res.statusCode == 200) {
      final jsonMap = json.decode(res.body);
      return MyProduct.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load product with ID $id');
    }
  }

  static Future<List<MyProduct>> fetchProductsByIds(List<int> ids) async {
    List<MyProduct> products = [];
    for (int id in ids) {
      try {
        final product = await fetchProductById(id);
        products.add(product);
      } catch (_) {
        continue;
      }
    }
    return products;
  }
}
