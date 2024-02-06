import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/models/transaction.dart';
import 'package:wallet/providers/user_provider.dart';
import 'package:wallet/transaction_history.dart';

const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
const textStyleForUser = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  TransctionHistory? transctionHistory;
  bool isFilter = false;
  String filterValue = 'cash-in';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transctionHistory = TransctionHistory();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transction Histroy'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<TransactionModel>>(
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var list = snapshot.data!;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, int index) {
                TransactionModel data = list[index];
                if (data.userId == userProvider.getUser().id) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isFilter == false
                                      ? 'To'
                                      : filterValue == 'cash-in'
                                          ? 'From'
                                          : 'To',
                                  style: textStyleForUser,
                                ),
                                Text(
                                  isFilter == false
                                      ? '->'
                                      : filterValue == 'cash-in'
                                          ? '<-'
                                          : '->',
                                  style: textStyleForUser,
                                ),
                                Text(
                                  isFilter == false
                                      ? data.to.username
                                      : filterValue == 'cash-in'
                                          ? data.from.username
                                          : data.to.username,
                                  style: textStyleForUser,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '${data.amount} - SGD',
                              style: textStyleForUser,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
          stream: isFilter == false
              ? transctionHistory?.listController.stream
              : transctionHistory?.cashInController.stream),
    );
  }
}
