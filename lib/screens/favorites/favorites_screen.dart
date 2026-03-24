import 'package:flutter/material.dart';
import 'package:formation_flutter/core/services/pocketbase_service.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/homepage/product_list_item.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>>? _favorites;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final favorites = await PocketBaseService().getFavorites();
      if (mounted) {
        setState(() {
          _favorites = favorites;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes favoris',
          style: TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(),
    );
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
              onPressed: _loadFavorites,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_favorites == null || _favorites!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, color: AppColors.grey2, size: 64),
            const SizedBox(height: 16),
            Text(
              'Aucun favori pour le moment',
              style: TextStyle(
                color: AppColors.grey2,
                fontFamily: 'Avenir',
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      color: AppColors.yellow,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _favorites!.length,
        itemBuilder: (context, index) {
          final item = _favorites![index];
          return ProductListItem(
            name: item['name'] ?? '',
            brand: item['brand'] ?? '',
            imageUrl: item['image_url'] ?? '',
            nutriScore: item['nutri_score'] ?? '',
            onTap: () {
              context.push('/product', extra: item['barcode']).then((_) => _loadFavorites());
            },
          );
        },
      ),
    );
  }
}
