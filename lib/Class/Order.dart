class UserOrderList {
  final int id;
  final int id_customer;
  final int? id_user;
  final String full_name;
  final int phone;
  final String email;
  final String address;
  final String? note;
  final int total_amount;
  final String date_order;
  final String time_order;
  final String? canceled_at;
  final String? delivery_at;
  final String payment_method;
  final int? id_voucher;
  final int status;

  const UserOrderList({
    required this.id,
    required this.id_customer,
    required this.id_user,
    required this.full_name,
    required this.phone,
    required this.email,
    required this.address,
    required this.note,
    required this.total_amount,
    required this.date_order,
    required this.time_order,
    required this.canceled_at,
    required this.delivery_at,
    required this.payment_method,
    required this.id_voucher,
    required this.status,
  });

  factory UserOrderList.fromJson(Map<String, dynamic> json){
    return UserOrderList(
      id: json['id'] as int,
      id_customer: json['id_customer'] as int,
      id_user: json['id_user'] == null ? null : json['id_user'] as int,
      full_name: json['full_name'] as String,
      phone: json['phone'] as int,
      email: json['email'] as String,
      address: json['address'] as String,
      note: json['note'] == null ? "" : json['note'] as String,
      total_amount: json['total_amount'] as int,
      date_order: json['date_order'] as String,
      time_order: json['time_order'] as String,
      canceled_at: json['canceled_at'] == null ? "" : json['canceled_at'] as String,
      delivery_at: json['delivery_at'] == null ? "" : json['delivery_at'] as String,
      payment_method: json['payment_method'] as String,
      id_voucher: json['id_voucher'] == null ? null : json['id_voucher'] as int,
      status: json['status'] as int,
    );
  }
}