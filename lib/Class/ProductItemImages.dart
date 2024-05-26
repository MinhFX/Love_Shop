class ProductItemImages {
  final String image;

  const ProductItemImages({
    required this.image,
  });

  factory ProductItemImages.fromJson(Map<String, dynamic> json){
    return ProductItemImages(
      image: json['image'] as String,
    );
  }
}