// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:nyzo_wallet/Activities/BackupSeed.dart';
import 'package:nyzo_wallet/Activities/CycleTransactions.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';
import 'package:nyzo_wallet/Data/AppLocalizations.dart';
import 'package:nyzo_wallet/Data/Utils.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/Widgets/ColorTheme.dart';
import 'package:nyzo_wallet/homePage.dart';

class SettingsWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsWindowState();
}

class SettingsWindowState extends State<SettingsWindow> {
  WalletWindowState? walletWindowState;

  bool _switchValue = false;
  bool _nightMode = false;
  String version = '';
  @override
  void initState() {
    Utils.getVersion().then((String onValue) {
      version = onValue;
    });
    walletWindowState = context.findAncestorStateOfType<WalletWindowState>();
    watchSentinels().then((bool? val) {
      setState(() {
        _switchValue = val!;
      });
    });
    getNightModeValue().then((bool? value) {
      setState(() {
        _nightMode = value!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Expanded(
            flex: 3,
            child: Container(),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('String30'),
              style: TextStyle(
                  color: ColorTheme.of(context)!.secondaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  fontSize: 35),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          InkWell(
            onTap: () {
              final WalletWindowState? foldingCellState =
                  context.findAncestorStateOfType<WalletWindowState>();

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BackUpSeed(foldingCellState!.password)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Container(
                    decoration: BoxDecoration(
                        color: ColorTheme.of(context)!.baseColor,
                        borderRadius: BorderRadius.circular(5000),
                        border: Border.all(color: const Color(0xFF666666))),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        AppLocalizations.of(context)!.translate('String31'),
                        style: TextStyle(
                            color: ColorTheme.of(context)!.secondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          AppLocalizations.of(context)!.translate('String32'),
                          style: const TextStyle(color: Colors.black),
                        ),
                        content: Text(AppLocalizations.of(context)!
                            .translate('String33')),
                        actions: <Widget>[
                          TextButton(
                            child: Text(AppLocalizations.of(context)!
                                .translate('String34')),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('String35'),
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: AppLocalizations.of(context)!
                                              .locale
                                              .languageCode ==
                                          'nl'
                                      ? 11
                                      : null),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              setNightModeValue(false);
                              setState(() {
                                _nightMode = false;
                              });
                              deleteWallet();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomePage()),
                              );
                              ColorTheme.of(context)!.update!();
                              ColorTheme.of(context)!.updateAddressesToWatch!();
                              ColorTheme.of(context)!.updateVerifiers!();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorTheme.of(context)!.baseColor,
                      borderRadius: BorderRadius.circular(5000),
                      border: Border.all(color: const Color(0xFF666666))),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate('String36'),
                      style: TextStyle(
                          color: ColorTheme.of(context)!.secondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ),
                  width: double.infinity,
                ),
              ),
            ),
          ),
          kIsWeb ? const SizedBox() :
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorTheme.of(context)!.baseColor,
                  borderRadius: BorderRadius.circular(5000),
                  border: Border.all(color: const Color(0xFF666666))),
              child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      leading: Text(
                        AppLocalizations.of(context)!.translate('String37'),
                        style: TextStyle(
                            color: ColorTheme.of(context)!.secondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      trailing: Switch(
                        inactiveTrackColor:
                            ColorTheme.of(context)!.transparentColor,
                        activeColor: ColorTheme.of(context)!.secondaryColor,
                        value: _switchValue,
                        onChanged: (bool val) {
                          if (val) {
                            setState(() {
                              _switchValue = val;
                            });
                            setWatchSentinels(val);
                            walletWindowState!.setState(() {
                              walletWindowState!.sentinels = true;
                              walletWindowState!.pageIndex = 4;
                            });
                          } else {
                            setState(() {
                              _switchValue = val;
                            });
                            setWatchSentinels(val);
                            walletWindowState!.setState(() {
                              walletWindowState!.sentinels = false;
                              walletWindowState!.pageIndex = 3;
                            });
                          }
                        },
                      ),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorTheme.of(context)!.baseColor,
                  borderRadius: BorderRadius.circular(5000),
                  border: Border.all(color: const Color(0xFF666666))),
              child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      leading: Text(
                        AppLocalizations.of(context)!.translate('String38'),
                        style: TextStyle(
                            color: ColorTheme.of(context)!.secondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      trailing: Switch(
                        inactiveTrackColor:
                            ColorTheme.of(context)!.transparentColor,
                        activeColor: ColorTheme.of(context)!.secondaryColor,
                        value: _nightMode,
                        onChanged: (bool val) {
                          final ColorTheme colorTheme = ColorTheme.of(context)!;
                          if (val) {
                            setState(() {
                              _nightMode = val;
                            });
                            setNightModeValue(val);

                            colorTheme.update!();
                          } else {
                            setState(() {
                              _nightMode = val;
                            });
                            setNightModeValue(val);

                            colorTheme.update!();
                          }
                        },
                      ),
                    ),
                  )),
            ),
          ),
          kIsWeb ? const SizedBox() :
          InkWell(
            onTap: () {
              final WalletWindowState? foldingCellState =
                  context.findAncestorStateOfType<WalletWindowState>();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CycleTxScreen(foldingCellState!.password)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Container(
                    decoration: BoxDecoration(
                        color: ColorTheme.of(context)!.baseColor,
                        borderRadius: BorderRadius.circular(5000),
                        border: Border.all(color: const Color(0xFF666666))),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Cycle TXs',
                        style: TextStyle(
                            color: ColorTheme.of(context)!.secondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorTheme.of(context)!.baseColor,
                  borderRadius: BorderRadius.circular(5000),
                  border: Border.all(color: const Color(0xFF666666))),
              child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Beta v' + version,
                      style: TextStyle(
                          color: ColorTheme.of(context)!.secondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate('String39') + ' ',
                  style: TextStyle(
                    color: ColorTheme.of(context)!.secondaryColor,
                  ),
                ),
                Icon(
                  Icons.favorite,
                  color: ColorTheme.of(context)!.secondaryColor,
                  size: 15,
                ),
                Text(' ' + AppLocalizations.of(context)!.translate('String40'),
                    style: TextStyle(
                        color: ColorTheme.of(context)!.secondaryColor))
              ],
            ),
          )
        ],
      ),
    );
  }
}
