import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wallet/models/user.dart';
import 'package:wallet/providers/user_provider.dart';

const storage = FlutterSecureStorage();

class TransferWallet extends StatefulWidget {
  final User transferUser;
  const TransferWallet({super.key, required this.transferUser});

  @override
  State<TransferWallet> createState() => _TransferWalletState();
}

const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
const textStyleForUser = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

class _TransferWalletState extends State<TransferWallet> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Waller'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From',
                      style: textStyle,
                    ),
                    Icon(Icons.arrow_right_alt),
                    Text(
                      'To',
                      style: textStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userProvider.getUser().name,
                      style: textStyleForUser,
                    ),
                    Text(
                      widget.transferUser.name!,
                      style: textStyleForUser,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Current Amount - ${userProvider.getUser().amount}',
                  style: textStyleForUser,
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () async {
                          int amount = int.parse(_amountController.text);
                          if (amount > userProvider.getUser().amount) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Insufficient Amount'),
                              ),
                            );
                            return;
                          }
                          FocusScope.of(context).unfocus();
                          var user =
                              FirebaseFirestore.instance.collection('users');
                          user.doc(await storage.read(key: 'user_id')).update({
                            'amount': userProvider.getUser().amount - amount,
                          });
                          await FirebaseFirestore.instance
                              .collection('transactions')
                              .doc()
                              .set({
                            'user_id': userProvider.getUser().id,
                            'amount': amount,
                            'createdAt': Timestamp.now(),
                            'from': {
                              'username': userProvider.getUser().name,
                              'email': userProvider.getUser().email,
                              'user_id': userProvider.getUser().id,
                              'type': 'cash-out'
                            },
                            'to': {
                              'username': widget.transferUser.name,
                              'email': widget.transferUser.email,
                              'user_id': widget.transferUser.id,
                              'type': 'cash-in'
                            }
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Transfer')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
