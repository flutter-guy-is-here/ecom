class MyProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  MyProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': {'name': category},
        'images': [image],
      };

  factory MyProduct.fromJson(Map<String, dynamic> json) {
    return MyProduct(
      id: json['id'],
      title: json['title'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'],
      description: json['description'],
      category: json['category']['name'],
      image: json['images'][0],
    );
  }
}
