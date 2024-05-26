class ProductCart {
  final int id_pro;
  final int id_pro_item;
  final int id_size;
  final int id_color;
  int quantity;
  final String product_name;
  final String color_name;
  final String size_name;
  final String image;
  final int price;
  final int id_for_order;

  ProductCart({
    required this.id_pro,
    required this.id_pro_item,
    required this.id_size,
    required this.id_color,
    required this.quantity,
    required this.product_name,
    required this.color_name,
    required this.size_name,
    required this.image,
    required this.id_for_order,
    required this.price
  });

  Map<String, dynamic> toJson() {
    return {
      'id_pro': id_pro,
      'id_pro_item': id_pro_item,
      'id_size' : id_size,
      'id_color' : id_color,
      'quantity' : quantity,
      'product_name' : product_name,
      'color_name': color_name,
      'size_name': size_name,
      'image' : image,
      'id_for_order' : id_for_order,
      'price': price,
    };
  }

  factory ProductCart.fromJson(Map<String, dynamic> json){
    return ProductCart(
      id_pro: json['id_pro'] as int,
      id_pro_item: json['id_pro_item'] as int,
      id_size: json['id_size'] as int,
      id_color: json['id_color'] as int,
      quantity: json['quantity'] as int,
      product_name: json['product_name'] as String,
      color_name: json['color_name'] as String,
      size_name: json['size_name'] as String,
      image: json['image'] as String,
      price: json['price'] as int,
      id_for_order: json['id_for_order'] as int,
    );
  }
}