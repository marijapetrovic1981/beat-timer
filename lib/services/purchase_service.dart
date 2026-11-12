import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
  static const String _appleApiKey = 'appl_nKFJnaelKCylSGArsUUwHOWPxBA';
  // TODO: Add Google API key when Google Play is set up
  // static const String _googleApiKey = 'goog_xxxxxxxxxxxxx';

  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  bool _isInitialized = false;

  Future<void> init() async {
    // Skip on web - RevenueCat doesn't support web
    if (kIsWeb) return;
    if (_isInitialized) return;

    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      configuration = PurchasesConfiguration(_appleApiKey);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // TODO: Uncomment when Google Play is set up
      // configuration = PurchasesConfiguration(_googleApiKey);
      return; // Skip initialization on Android for now
    } else {
      return; // Not supported on other platforms
    }

    await Purchases.configure(configuration);
    _isInitialized = true;
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
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<bool> purchaseProduct(StoreProduct product) async {
    if (kIsWeb || !_isInitialized) return false;

    try {
      await Purchases.purchaseStoreProduct(product);
      return true;
    } catch (e) {
      print('Error purchasing: $e');
      return false;
    }
  }
}
