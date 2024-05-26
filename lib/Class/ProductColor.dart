class ProductColor {
  final int id_product;
  final int id_product_item;
  final int id_color;
  final String color_name;
  final String image;

  const ProductColor({
    required this.id_product,
    required this.id_product_item,
    required this.id_color,
    required this.color_name,
    required this.image,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json){
    return ProductColor(
      id_product: json['id_product'] as int,
      id_product_item: json['id'] as int,
      id_color: json['id_color'] as int,
      image: json['image'] as String,
      color_name: json['color_name'] as String,
    );
  }
}