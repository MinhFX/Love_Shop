class ProductMenu {
  final int id;
  final int id_pro;
  final int id_pro_category;
  final String product_name;
  final String image;
  final int status;
  final int price;
  final int id_color;
  final int discount_price;
  final int pro_item_id;
  final String description;

  const ProductMenu({
    required this.id,
    required this.product_name,
    required this.image,
    required this.status,
    required this.description,
    required this.id_pro,
    required this.id_pro_category,
    required this.price,
    required this.discount_price,
    required this.id_color,
    required this.pro_item_id,
  });

  factory ProductMenu.fromJson(Map<String, dynamic> json){
    return ProductMenu(
      id: json['id'] as int,
      product_name: json['product_name'] as String,
      image: json['image'] as String,
      status: json['status'] as int,
      description: json['description'] as String,
      id_pro: json['id_product'] as int,
      id_color: json['id_color'] as int,
      id_pro_category: json['id_pro_category'] as int,
      price: json['price'] as int,
      pro_item_id: json['product_item_id'] as int,
      discount_price: json['discount_price'] as int,
    );
  }
}