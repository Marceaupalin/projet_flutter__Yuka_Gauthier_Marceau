import 'package:flutter/material.dart';
import 'package:formation_flutter/core/services/pocketbase_service.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/homepage/product_list_item.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>>? _history;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final history = await PocketBaseService().getHistory();
      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onScanButtonPressed() {
    context.push('/scanner').then((_) => _loadHistory());
  }

  void _onFavoritesPressed() {
    context.push('/favorites');
  }

  void _onLogoutPressed() async {
    await PocketBaseService().logout();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes scans',
          style: TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (_history != null && _history!.isNotEmpty)
            IconButton(
              onPressed: _onScanButtonPressed,
              icon: Icon(AppIcons.barcode, color: AppColors.blue),
            ),
          IconButton(
            onPressed: _onFavoritesPressed,
            icon: Icon(Icons.star, color: AppColors.blue),
          ),
          IconButton(
            onPressed: _onLogoutPressed,
            icon: Icon(Icons.logout, color: AppColors.blue),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: (_history == null || _history!.isEmpty) && !_isLoading
          ? FloatingActionButton.extended(
              onPressed: _seedSampleData,
              label: const Text('Générer un exemple'),
              icon: const Icon(Icons.auto_awesome),
              backgroundColor: AppColors.yellow,
              foregroundColor: AppColors.blue,
            )
          : null,
    );
  }

  Future<void> _seedSampleData() async {
    setState(() => _isLoading = true);
    try {
      final pb = PocketBaseService();
      final api = OpenFoodFactsAPI();
      
      final barcodes = ["3017620422003", "3274080005003", "7622210449283"];
      
      for (final barcode in barcodes) {
        try {
          final product = await api.getProduct(barcode);
          await pb.addToHistory(
            barcode, 
            product.name, 
            product.brands?.join(', '), 
            product.picture, 
            product.nutriScore?.name
          );
          if (barcode != "3274080005003") {
            await pb.addToFavorites(
              barcode, 
              product.name, 
              product.brands?.join(', '), 
              product.picture, 
              product.nutriScore?.name
            );
          }
        } catch (_) {}
      }
    } finally {
      await _loadHistory();
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                color: AppColors.blue,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadHistory,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_history == null || _history!.isEmpty) {
      return HomePageEmpty(onScan: _onScanButtonPressed);
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      color: AppColors.yellow,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _history!.length,
        itemBuilder: (context, index) {
          final item = _history![index];
          return ProductListItem(
            name: item['name'] ?? '',
            brand: item['brand'] ?? '',
            imageUrl: item['image_url'] ?? '',
            nutriScore: item['nutri_score'] ?? '',
            onTap: () {
              context.push('/product', extra: item['barcode']).then((_) => _loadHistory());
            },
          );
        },
      ),
    );
  }
}
