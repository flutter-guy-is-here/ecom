import 'package:flutter/material.dart';

import '../models/Product.dart';

class MyProductTile extends StatelessWidget {
  const MyProductTile({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.quantity,
    required this.onFavoriteToggle,
    required this.onAdd,
    required this.onRemove,
  });

  final MyProduct product;
  final bool isFavorite;
  final int quantity;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        leading: Image.network(product.image, width: 50, height: 50),
        title:
            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('\$${product.price.toString()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: onFavoriteToggle,
            ),
            if (quantity > 0) ...[
              IconButton(icon: const Icon(Icons.remove), onPressed: onRemove),
              Text(quantity.toString()),
              IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
            ] else
              IconButton(
                  icon: const Icon(Icons.add_shopping_cart), onPressed: onAdd),
          ],
        ),
      ),
    );
  }
}
