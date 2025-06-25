body: IndexedStack(
        index: currentIndex,
        children: [
          ProductsTab(
            categories: categories,
            products: products,
            isLoadingProducts: isLoadingProducts,
            isLoadingCategories: isLoadingCategories,
            productError: productError,
            categoryError: categoryError,
            onCategorySelected: loadProducts,
          ),
          const FavoritesTab(),
          const CartTab(),
        ],
      ),
