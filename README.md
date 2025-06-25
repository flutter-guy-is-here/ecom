  index: currentIndex,
  children: [
    ProductTab(
      products: products,
      categories: categories,
      onCategorySelected: loadProducts,
      ...
    ),
    FavoritesTab(),
    CartTab(),
  ],
)
