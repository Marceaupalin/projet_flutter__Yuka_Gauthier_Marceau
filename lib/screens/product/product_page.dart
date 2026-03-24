import 'package:flutter/material.dart';
import 'package:formation_flutter/core/services/pocketbase_service.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/states/empty/product_page_empty.dart';
import 'package:formation_flutter/screens/product/states/error/product_page_error.dart';
import 'package:formation_flutter/screens/product/states/success/product_page_body.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.barcode})
    : assert(barcode.length > 0);

  final String barcode;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _isFavorite = false;
  bool _historySaved = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    try {
      final fav = await PocketBaseService().isFavorite(widget.barcode);
      if (mounted) {
        setState(() => _isFavorite = fav);
      }
    } catch (_) {}
  }

  Future<void> _toggleFavorite(Product product) async {
    try {
      if (_isFavorite) {
        await PocketBaseService().removeFromFavorites(widget.barcode);
      } else {
        await PocketBaseService().addToFavorites(
          widget.barcode,
          product.name,
          product.brands?.join(', '),
          product.picture,
          product.nutriScore?.name,
        );
      }
      if (mounted) {
        setState(() => _isFavorite = !_isFavorite);
      }
    } catch (_) {}
  }

  Future<void> _saveToHistory(Product product) async {
    if (_historySaved) return;
    _historySaved = true;
    try {
      await PocketBaseService().addToHistory(
        widget.barcode,
        product.name,
        product.brands?.join(', '),
        product.picture,
        product.nutriScore?.name,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);

    return ChangeNotifierProvider<ProductFetcher>(
      create: (_) => ProductFetcher(barcode: widget.barcode),
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<ProductFetcher>(
              builder: (BuildContext context, ProductFetcher notifier, _) {
                if (notifier.state is ProductFetcherSuccess) {
                  final product = (notifier.state as ProductFetcherSuccess).product;
                  _saveToHistory(product);
                }

                return switch (notifier.state) {
                  ProductFetcherLoading() => const ProductPageEmpty(),
                  ProductFetcherError(error: var err) => ProductPageError(
                    error: err,
                  ),
                  ProductFetcherSuccess() => ProductPageBody(),
                };
              },
            ),
            PositionedDirectional(
              top: 0.0,
              start: 0.0,
              child: _HeaderIcon(
                icon: Icons.arrow_back,
                tooltip: materialLocalizations.backButtonTooltip,
                onPressed: Navigator.of(context).pop,
              ),
            ),
            PositionedDirectional(
              top: 0.0,
              end: 0.0,
              child: Consumer<ProductFetcher>(
                builder: (context, notifier, _) {
                  return _HeaderIcon(
                    icon: _isFavorite ? Icons.star : Icons.star_border,
                    tooltip: 'Favoris',
                    onPressed: () {
                      if (notifier.state is ProductFetcherSuccess) {
                        _toggleFavorite(
                          (notifier.state as ProductFetcherSuccess).product,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.tooltip, this.onPressed})
    : assert(tooltip.length > 0);

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: Tooltip(
            message: tooltip,
            child: InkWell(
              onTap: onPressed ?? () {},
              customBorder: const CircleBorder(),
              child: Ink(
                padding: const EdgeInsetsDirectional.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.0),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
