import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
  static const String _appleApiKey = 'appl_nKFJnaelKCylSGArsUUwHOWPxBA';
  static const String _googleApiKey = 'goog_PpbWvYrzFLhmrcpwXmjLMqlKaai';

  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  bool _isInitialized = false;

  Future<void> init() async {
    // Skip on web - RevenueCat doesn't support web
    if (kIsWeb) return;
    if (_isInitialized) return;

    try {
      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration configuration;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        configuration = PurchasesConfiguration(_appleApiKey);
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        configuration = PurchasesConfiguration(_googleApiKey);
      } else {
        return; // Not supported on other platforms
      }

      await Purchases.configure(configuration);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
      // Don't crash the app if RevenueCat fails to initialize
    }
  }

  Future<List<StoreProduct>> getProducts() async {
    if (kIsWeb || !_isInitialized) return [];

    try {
      final products = await Purchases.getProducts(
        [
          'small_tip',
          'medium_tip',
          'large_tip',
          'super_tip',
        ],
        productCategory: ProductCategory.nonSubscription,
      );
      
      // Sort by price
      products.sort((a, b) => a.price.compareTo(b.price));
      return products;
    } catch (e) {
      debugPrint('Error fetching products: $e');
      return [];
    }
  }

  Future<bool> purchaseProduct(StoreProduct product) async {
    if (kIsWeb || !_isInitialized) return false;

    try {
      await Purchases.purchase(PurchaseParams.storeProduct(product));
      return true;
    } catch (e) {
      debugPrint('Error purchasing: $e');
      return false;
    }
  }
}
