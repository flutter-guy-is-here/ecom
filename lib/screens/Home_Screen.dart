import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_services.dart';
import 'package:flutter/material.dart';
import '../components/Product_tile.dart';
import '../models/Product.dart';
import '../models/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<MyProduct> products = [];
  List<MyProduct> favorites = [];
  List<MyProduct> cartProducts = [];
  Map<int, int> cart = {};
  String? selectedCategory;
  int currentIndex = 0;
  bool isLoadingProducts = false;
  bool isLoadingCategories = false;
  String? productError;
  String? categoryError;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadProducts();
    loadFavorites();
    loadCart();
  }

  void loadCategories() async {
    var mycategories = await ApiService.fetchCategories();
    setState(() {
      categories = mycategories;
    });
  }

  void loadProducts([String? category]) async {
    setState(() {
      isLoadingProducts = true;
      productError = null;
    });
    try {
      final data = await ApiService.fetchProducts(category);
      setState(() {
        selectedCategory = category;
        products = data;
        isLoadingProducts = false;
      });
    } catch (_) {
      setState(() {
        productError = 'There was a problem with your internet.';
        isLoadingProducts = false;
      });
    }
  }

  void toggleFavorite(MyProduct product) async {
    setState(() {
      if (favorites.any((p) => p.id == product.id)) {
        favorites.removeWhere((p) => p.id == product.id);
      } else {
        favorites.add(product);
      }
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList('favorites', jsonList);
  }

  void addToCart(MyProduct product) async {
    setState(() {
      cart.update(product.id, (value) => value + 1, ifAbsent: () => 1);
    });
    await saveCart();
  }

  void removeFromCart(MyProduct product) async {
    setState(() {
      if (cart.containsKey(product.id)) {
        if (cart[product.id]! > 1) {
          cart[product.id] = cart[product.id]! - 1;
        } else {
          cart.remove(product.id);
        }
      }
    });
    await saveCart();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartMap =
        cart.map((id, qty) => MapEntry(id.toString(), qty.toString()));
    await prefs.setString('cart_map', json.encode(cartMap));
  }

  void loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartStr = prefs.getString('cart_map');
    if (cartStr != null) {
      final decoded = Map<String, dynamic>.from(json.decode(cartStr));
      final mapped =
          decoded.map((k, v) => MapEntry(int.parse(k), int.parse(v)));
      setState(() => cart = mapped);
    }
  }

  // void loadCartProducts() async {
  //   setState(() {
  //     isLoadingCart = true;
  //     cartError = null;
  //     cartProducts = [];
  //   });

  //   try {
  //     final productIds = cart.keys.toList();
  //     final items = await ApiService.fetchProductsByIds(productIds);
  //     setState(() => cartProducts = items);
  //   } catch (_) {
  //     setState(() => cartError = 'There was a problem with your internet.');
  //   } finally {
  //     setState(() => isLoadingCart = false);
  //   }
  // }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('favorites') ?? [];
    final loaded = jsonList
        .map((jsonStr) => MyProduct.fromJson(json.decode(jsonStr)))
        .toList();
    setState(() => favorites = loaded);
  }

  bool isFavorite(MyProduct product) {
    return favorites.any((p) => p.id == product.id);
  }

  int getQuantity(MyProduct product) {
    return cart[product.id] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formation project"),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => setState(() => currentIndex = 2),
          )
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
          ]),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: const Text("Formation project"),
      centerTitle: true,
      elevation: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => setState(() => currentIndex = 2),
        )
      ],
    );
  }

  Widget buildBody() {
    if (currentIndex == 1) {
      return favorites.isEmpty
          ? Center(
              child: Text("Za3ma sa7 ma3ajbak hetta produit!"),
            )
          : ListView(
              children: favorites
                  .map((p) => MyProductTile(
                        product: p,
                        isFavorite: true,
                        quantity: getQuantity(p),
                        onFavoriteToggle: () => toggleFavorite(p),
                        onAdd: () => addToCart(p),
                        onRemove: () => removeFromCart(p),
                      ))
                  .toList(),
            );
    } else if (currentIndex == 2) {
      return ListView(
        children: cart.keys.map((id) {
          final product = products.firstWhere((p) => p.id == id,
              orElse: () => favorites.firstWhere((f) => f.id == id));
          return MyProductTile(
            product: product,
            isFavorite: isFavorite(product),
            quantity: getQuantity(product),
            onFavoriteToggle: () {},
            onAdd: () => addToCart(product),
            onRemove: () => removeFromCart(product),
          );
        }).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return InkWell(
                onTap: () => loadProducts(cat.name),
                child: Container(
                  width: 100,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(cat.image,
                            height: 60,
                            width: double.infinity,
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 4),
                      Text(cat.name, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: isLoadingProducts
              ? const Center(child: CircularProgressIndicator())
              : productError != null
                  ? Center(child: Text(productError!))
                  : products.isEmpty
                      ? const Center(child: Text('Makache products :('))
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return MyProductTile(
                              product: product,
                              isFavorite: isFavorite(product),
                              quantity: getQuantity(product),
                              onFavoriteToggle: () => toggleFavorite(product),
                              onAdd: () => addToCart(product),
                              onRemove: () => removeFromCart(product),
                            );
                          },
                        ),
        )
      ],
    );
  }
}


// else if (currentIndex == 2) {
//   return isLoadingCart
//       ? const Center(child: CircularProgressIndicator())
//       : cartError != null
//           ? Center(child: Text(cartError!))
//           : cartProducts.isEmpty
//               ? const Center(child: Text("Cart is empty"))
//               : ListView(
//                   children: cartProducts.map((product) {
//                     return ProductTile(
//                       product: product,
//                       isFavorite: isFavorite(product),
//                       quantity: getQuantity(product),
//                       onFavoriteToggle: () {},
//                       onAdd: () => addToCart(product),
//                       onRemove: () => removeFromCart(product),
//                     );
//                   }).toList(),
//                 );
// }

  