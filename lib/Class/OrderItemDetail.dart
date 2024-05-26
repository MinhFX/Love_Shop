class OrderItemDetail {
  final String product_name;
  final String color_name;
  final String size_name;
  final String image;
  final int price;
  final int quantity;

  OrderItemDetail({
    required this.quantity,
    required this.product_name,
    required this.color_name,
    required this.size_name,
    required this.image,
    required this.price
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json){
    return OrderItemDetail(
      quantity: json['quantity'] as int,
      product_name: json['product_name'] as String,
      color_name: json['color_name'] as String,
      size_name: json['size_name'] as String,
      image: json['image'] as String,
      price: json['price'] as int,
    );
  }
}