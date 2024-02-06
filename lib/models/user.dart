import 'dart:convert';

// User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? name;
  String? email;
  int? amount;
  String? id;

  User(
      {required this.name,
      required this.email,
      required this.amount,
      required this.id});

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "amount": amount,
      };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['user_id'],
        name: map['username'] ?? '',
        email: map['email'] ?? '',
        amount: map['amount'] ?? 0);
  }
}
