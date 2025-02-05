// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:nyzo_wallet/Data/Verifier.dart';
import 'package:nyzo_wallet/Data/WatchedAddress.dart';

class ColorTheme extends InheritedWidget {
  const ColorTheme(
      {this.lightTheme,
      required this.child,
      this.update,
      this.baseColor,
      this.depthColor,
      this.secondaryColor,
      this.extraColor,
      this.transparentColor,
      this.highLigthColor,
      this.verifiersList,
      this.updateVerifiers,
      this.addressesToWatch,
      this.updateAddressesToWatch})
      : super(child: child);
  final Widget child;
  final bool? lightTheme;
  final Function? update;
  final Color? baseColor;
  final Color? depthColor;
  final Color? secondaryColor;
  final Color? extraColor;
  final Color? transparentColor;
  final Color? highLigthColor;
  final List<Verifier>? verifiersList;
  final Function? updateVerifiers;
  final List<WatchedAddress>? addressesToWatch;
  final Function? updateAddressesToWatch;

  @override
  bool updateShouldNotify(ColorTheme oldWidget) {
    return (lightTheme != oldWidget.lightTheme) ||
        (verifiersList != oldWidget.verifiersList) ||
        (addressesToWatch != oldWidget.addressesToWatch);
  }

  static ColorTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ColorTheme>();
  }
}
