import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/purchase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic_container.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  List<StoreProduct> _products = [];
  bool _isLoading = true;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await PurchaseService().getProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> _purchase(StoreProduct product) async {
    setState(() => _isPurchasing = true);
    
    final success = await PurchaseService().purchaseProduct(product);
    
    setState(() => _isPurchasing = false);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your support! 💜'),
          backgroundColor: AppTheme.colorWork,
        ),
      );
    }
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  String _getTipLabel(int index) {
    switch (index) {
      case 0:
        return 'Small Tip';
      case 1:
        return 'Medium Tip';
      case 2:
        return 'Large Tip';
      case 3:
        return 'Super Tip';
      default:
        return 'Tip';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => _goHome(context),
            tooltip: 'Go to Home',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            
            const Text(
              'Support Beat Timer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              'Beat Timer is free with no ads.\nIf you enjoy the app, consider leaving a tip!',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.colorWork,
                ),
              )
            else if (_products.isEmpty)
              NeumorphicContainer(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Tips are not available yet.\nPlease check back later!',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...List.generate(_products.length, (index) {
                final product = _products[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: _isPurchasing ? null : () => _purchase(product),
                    child: NeumorphicContainer(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: AppTheme.colorHeart,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getTipLabel(index),
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            product.priceString,
                            style: const TextStyle(
                              color: AppTheme.colorWork,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            
            const Spacer(),
            
            const Text(
              'Thank you for using Beat Timer! 💜',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
