class CategoriesProduct {
  final int id;
  final String category_name;
  final String image;
  final int status;
  final String description;

  const CategoriesProduct({
    required this.id,
    required this.category_name,
    required this.image,
    required this.status,
    required this.description
  });

  factory CategoriesProduct.fromJson(Map<String, dynamic> json){
    return CategoriesProduct(
      id: json['id'] as int,
      category_name: json['category_name'] as String,
      image: json['image'] as String,
      status: json['status'] as int,
      description: json['description'] as String,
    );
  }
}