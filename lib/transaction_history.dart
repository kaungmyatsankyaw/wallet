import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallet/models/transaction.dart';
import 'package:wallet/providers/user_provider.dart';

class TransctionHistory {
  static late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      subscription;
  late StreamController<List<TransactionModel>> listController;
  late StreamController<List<TransactionModel>> cashInController;
  late StreamController<List<TransactionModel>> cashOutController;
  UserProvider userProvider = UserProvider();

  TransctionHistory() {
    listController = StreamController<List<TransactionModel>>();
    cashInController = StreamController<List<TransactionModel>>();
    cashOutController = StreamController<List<TransactionModel>>();

    subscription = FirebaseFirestore.instance
        .collection('transactions')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<TransactionModel> transactions = [];
      List<TransactionModel> inTransactions = [];
      List<TransactionModel> outTransactions = [];

      for (var doc in snapshot.docs) {
        TransactionModel history = TransactionModel.fromMap(doc.data());
        transactions.add(history);
        if (history.to.userId == userProvider.getUser().id) {
          inTransactions.add(history);
        } else {
          outTransactions.add(history);
        }
      }

      listController.add(transactions);
      cashInController.add(inTransactions);
      cashOutController.add(outTransactions);
    });
  }

  void dispose() {
    subscription.cancel();
    listController.close();
    cashInController.close();
    cashOutController.close();
  }
}
