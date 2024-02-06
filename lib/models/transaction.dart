// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromMap(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromMap(String str) => TransactionModel.fromMap(json.decode(str));

String transactionModelToMap(TransactionModel data) => json.encode(data.toMap());

class TransactionModel {
    int amount;
    String userId;
    From from;
    From to;

    TransactionModel({
        required this.amount,
        required this.userId,
        required this.from,
        required this.to,
    });

    factory TransactionModel.fromMap(Map<String, dynamic> json) => TransactionModel(
        amount: json["amount"],
        userId: json["user_id"],
        from: From.fromMap(json["from"]),
        to: From.fromMap(json["to"]),
    );

    Map<String, dynamic> toMap() => {
        "amount": amount,
        "user_id": userId,
        "from": from.toMap(),
        "to": to.toMap(),
    };
}

class From {
    String userId;
    String type;
    String email;
    String username;

    From({
        required this.userId,
        required this.type,
        required this.email,
        required this.username,
    });

    factory From.fromMap(Map<String, dynamic> json) => From(
        userId: json["user_id"],
        type: json["type"],
        email: json["email"],
        username: json["username"],
    );

    Map<String, dynamic> toMap() => {
        "user_id": userId,
        "type": type,
        "email": email,
        "username": username,
    };
}
