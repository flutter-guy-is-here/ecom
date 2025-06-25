// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../components/Product_tile.dart';
// import '../models/Product.dart';
// import '../services/api_services.dart';

// class CardTab extends StatefulWidget {
//   const CardTab({super.key});

//   @override
//   State<CardTab> createState() => _CardTabState();
// }

// class _CardTabState extends State<CardTab> {
//   Map<int, int> cart = {};
//   List<MyProduct> products = [];
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadCart();
//   }

//   void loadCart() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });
//     try {
//           final prefs = await SharedPreferences.getInstance();
//     final cartStr = prefs.getString('cart_map');
//     if (cartStr != null) {
//       final decoded = Map<String, dynamic>.from(json.decode(cartStr));
//       final mapped =
//           decoded.map((k, v) => MapEntry(int.parse(k), int.parse(v)));
//       final ids = mapped.keys.toList();
//       final items = await ApiService.fetchProductsByIds(ids);
//       setState(() => products = items);
//     }
//     } catch (e) {
//       setState(() => error = 'There was a problem with your internet.');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//    if(isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (error != null) {
//       return Center(child: Text(error!));
//     }
//     if (products.isEmpty) {
//       return const Center(child: Text('Cart is empty'));
//     }
//     return ListView.builder(
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         final product = products[index];
//         final quantity = cart[product.id] ?? 0;
//         return MyProductTile(product: product, quantity: quantity);
//       },
//     );
//   }
// }
