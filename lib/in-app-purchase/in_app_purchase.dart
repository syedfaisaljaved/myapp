import 'dart:io';

class InAppPurchase {
  InAppPurchase._privateConstructor();

  static final InAppPurchase _instance = InAppPurchase._privateConstructor();

  /// getter
  static InAppPurchase get instance => _instance;

  final bool _kAutoConsume = Platform.isIOS || true;

  static const String _kConsumableId = 'remove_ads';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

}