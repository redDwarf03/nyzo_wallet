// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:nyzo_wallet/Activities/WalletWindow.dart';
import 'package:nyzo_wallet/Data/AppLocalizations.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/Widgets/ColorTheme.dart';

class NewWalletScreen extends StatefulWidget {
  @override
  _NewWalletScreenState createState() => _NewWalletScreenState();
}

class _NewWalletScreenState extends State<NewWalletScreen> {
  bool _isLoading = false;
  final TextEditingController textController1 = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  final GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    //prevent the screen from rotating
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    textController2.dispose();
    textController1.dispose();
    super.dispose();
  }

  void _performWalletCreation() {
    setState(() {
      _isLoading = true;
    });

    createNewWallet(textController1.text).then((onValue) {
      ColorTheme.of(context)!.update!();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WalletWindow(
                  textController1.text,
                  '',
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Center(
                      child: Text(
                          AppLocalizations.of(context)!.translate('String18'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          )))),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autocorrect: false,
                    autofocus: false,
                    obscureText: true,
                    controller: textController1,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorTheme.of(context)!.depthColor,
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(color: Colors.red)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Color(0x55666666))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Color(0x55666666))),
                      contentPadding: const EdgeInsets.all(10),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText:
                          AppLocalizations.of(context)!.translate('String81'),
                      labelStyle: const TextStyle(
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  TextFormField(
                    key: formKey,
                    autocorrect: false,
                    controller: textController2,
                    obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorTheme.of(context)!.depthColor,
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(color: Colors.red)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Color(0x55666666))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Color(0x55666666))),
                      contentPadding: const EdgeInsets.all(10),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText:
                          AppLocalizations.of(context)!.translate('String84'),
                      labelStyle: const TextStyle(
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    validator: (String? val) => val != textController1.text
                        ? AppLocalizations.of(context)!.translate('String85')
                        : val == ''
                            ? AppLocalizations.of(context)!
                                .translate('String86')
                            : val!.length < 6
                                ? AppLocalizations.of(context)!
                                    .translate('String101')
                                : null,
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  if (_isLoading)
                    const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color?>(
                                Color(0xffffffff))))
                  else
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        onPressed: () {
                          final FormFieldState? form = formKey.currentState;
                          if (form!.validate()) {
                            _performWalletCreation();
                          }
                        },
                        child: Text(
                            AppLocalizations.of(context)!.translate('String19'),
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ));
  }
}
