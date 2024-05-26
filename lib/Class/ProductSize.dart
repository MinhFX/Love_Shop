class ProductSize {
  final int id;
  final int id_product_item;
  final int id_size;
  final int in_stock;
  final String size_name;

  const ProductSize({
    required this.id,
    required this.id_size,
    required this.id_product_item,
    required this.in_stock,
    required this.size_name,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json){
    return ProductSize(
      id: json['id'] as int,
      id_size: json['id_size'] as int,
      id_product_item: json['id_product_item'] as int,
      in_stock: json['in_stock'] as int,
      size_name: json['size_name'] as String,
    );
  }
}