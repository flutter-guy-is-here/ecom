class Category {
  final int id;
  final String name;
  final String slug;
  final String image;
  final String creationAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      creationAt: json['creationAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
