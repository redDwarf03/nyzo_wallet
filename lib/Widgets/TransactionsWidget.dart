// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:nyzo_wallet/Activities/MyTokensListWindow.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';
import 'package:nyzo_wallet/Data/AppLocalizations.dart';
import 'package:nyzo_wallet/Data/Contact.dart';
import 'package:nyzo_wallet/Data/Token.dart';
import 'package:nyzo_wallet/Data/TokensTransactionsResponse.dart';
import 'package:nyzo_wallet/Data/TransactionsSinceResponse.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/Widgets/ColorTheme.dart';
import 'package:nyzo_wallet/Widgets/SheetUtil.dart';
import 'package:nyzo_wallet/Widgets/TransactionsDetailsWidget.dart';

class TransactionsWidget extends StatefulWidget {
  const TransactionsWidget();
  @override
  TranSactionsWidgetState createState() => TranSactionsWidgetState();
}

class TranSactionsWidgetState extends State<TransactionsWidget> {
  List<TokensTransactionsResponse> tokensTransactionsList =
      List<TokensTransactionsResponse>.empty(growable: true);
  TransactionsSinceResponse? transactionsSinceResponse;
  TranSactionsWidgetState();
  String _address = '';
  List<Contact>? _contactsList;
  WalletWindowState? walletWindowState;

  @override
  void initState() {
    walletWindowState = context.findAncestorStateOfType<WalletWindowState>()!;
    getAddress().then((String address) {
      _address = address;
      getTokensTransactionsList(address)
          .then((List<TokensTransactionsResponse> _tokensTransactionsList) {
        setState(() {
          tokensTransactionsList = _tokensTransactionsList;
        });
      });
      getTransactionsSinceList(address)
          .then((TransactionsSinceResponse _transactionsSinceResponse) {
        setState(() {
          transactionsSinceResponse = _transactionsSinceResponse;
        });
      });
    });
    getContacts().then((List<Contact> contacts) {
      _contactsList = contacts;
    });
    super.initState();
  }

  Future<void> refresh() async {
    final WalletWindowState? walletWindowState =
        context.findAncestorStateOfType<WalletWindowState>();
    getBalance(_address).then((double _balance) {
      walletWindowState!.setState(() {
        walletWindowState.balance = _balance.floor();
        setSavedBalance(_balance);
      });
    });
    getTokensBalance(_address).then((List<Token> _myTokensList) {
      walletWindowState!.setState(() {
        walletWindowState.myTokensList = _myTokensList;
      });
    });
    getNFTBalance(_address).then((List<Token> _myNFTsList) {
      walletWindowState!.setState(() {
        walletWindowState.myNFTsList = _myNFTsList;
      });
    });
    getTransactionsSinceList(_address)
        .then((TransactionsSinceResponse _transactionsSinceResponse) {
      transactionsSinceResponse = _transactionsSinceResponse;
    });
    getContacts().then((List<Contact> contacts) {
      _contactsList = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('String72'),
              style: TextStyle(
                  color: ColorTheme.of(context)!.secondaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  fontSize: 35),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('String50'),
                      style: const TextStyle(
                          color: Color(0xFF555555), fontSize: 15),
                    ),
                    RichText(
                      text: TextSpan(
                        text: walletWindowState!.balance == 0
                            ? walletWindowState!.balance.toString()
                            : (walletWindowState!.balance / 1000000).toString(),
                        style: TextStyle(
                            color: ColorTheme.of(context)!.secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 40),
                        children: <TextSpan>[
                          kIsWeb
                              ? TextSpan(
                                  text: ' nyzo(s)',
                                  style: TextStyle(
                                      color: ColorTheme.of(context)!
                                          .secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                )
                              : TextSpan(
                                  text: ' ∩',
                                  style: TextStyle(
                                      color: ColorTheme.of(context)!
                                          .secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
                if (walletWindowState!.myTokensList.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Colors.transparent)
                          ],
                        ),
                        height: 35,
                        margin: const EdgeInsetsDirectional.only(
                            start: 7, top: 0.0, end: 7.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                ColorTheme.of(context)!.secondaryColor,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          child: ColorTheme.of(context)!.lightTheme!
                              ? Image.asset(
                                  'images/nytro-logo-black.png',
                                  height: 13,
                                )
                              : Image.asset(
                                  'images/nytro-logo-white.png',
                                  height: 13,
                                ),
                          onPressed: () {
                            Sheets.showAppHeightEightSheet(
                                color: ColorTheme.of(context)!.depthColor,
                                context: context,
                                widget: MyTokensListWindow(
                                    walletWindowState!.myTokensList,
                                    walletWindowState!.myNFTsList));
                          },
                        ),
                      ),
                      kIsWeb
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(color: Colors.transparent)
                                ],
                              ),
                              height: 35,
                              margin: const EdgeInsetsDirectional.only(
                                  start: 7, top: 0.0, end: 7.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      ColorTheme.of(context)!.secondaryColor,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                                child: Icon(Icons.refresh,
                                    color: ColorTheme.of(context)!.baseColor),
                                onPressed: () async {
                                  await refresh();
                                  setState(() {});
                                },
                              ),
                            )
                          : const SizedBox(),
                    ],
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFF555555),
          ),
          if (transactionsSinceResponse == null)
            const SizedBox()
          else
            TransactionsDetailsWidget.buildTransactionsDisplay(
                context,
                _address,
                walletWindowState!,
                transactionsSinceResponse!.txs,
                _contactsList,
                refresh),
        ],
      ),
    );
  }

  String splitJoinString(String address) {
    final String val = address.split('-').join('');
    return val;
  }
}
