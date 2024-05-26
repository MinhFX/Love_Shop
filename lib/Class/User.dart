class User {
  final int id;
  final String name;
  int? phone;
  final String email;
  final String point;
  String? birthday;
  String? address;
  int? gender;
  String? image;
  final int status;

  User({
    required this.id,
    required this.name,
    this.phone,
    required this.email,
    required this.point,
    this.birthday,
    this.address,
    this.gender,
    this.image,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] != null ? json['phone'] as int : null,
      email: json['email'] as String,
      point: json['point'] != null ? json['point'] as String : "0",
      birthday: json['birthday'] != null ? json['birthday'] as String : null,
      address: json['address'] != null ? json['address'] as String : null,
      gender: json['gender'] != null ? json['gender'] as int : null,
      image: json['image'] != null ? json['image'] as String : null,
      status: json['status'] as int,
    );
  }
}