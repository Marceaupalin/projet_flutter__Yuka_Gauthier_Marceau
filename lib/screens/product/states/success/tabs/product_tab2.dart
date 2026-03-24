import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              product.brands?.join(', ') ?? '',
              style: TextStyle(
                color: AppColors.grey2,
                fontFamily: 'Avenir',
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Repères nutritionnels pour 100g',
              style: TextStyle(
                color: AppColors.grey3,
                fontFamily: 'Avenir',
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (product.nutrientLevels != null) ...[
            _NutrientBlock(
              label: 'Matières grasses / lipides',
              value: _getFatValue(product),
              level: product.nutrientLevels!.fat ?? 'unknown',
            ),
            const SizedBox(height: 16),
            _NutrientBlock(
              label: 'Acides gras saturés',
              value: _getSaturatedFatValue(product),
              level: product.nutrientLevels!.saturatedFat ?? 'unknown',
            ),
            const SizedBox(height: 16),
            _NutrientBlock(
              label: 'Sucres',
              value: _getSugarValue(product),
              level: product.nutrientLevels!.sugars ?? 'unknown',
            ),
            const SizedBox(height: 16),
            _NutrientBlock(
              label: 'Sel',
              value: _getSaltValue(product),
              level: product.nutrientLevels!.salt ?? 'unknown',
            ),
          ] else
            Center(
              child: Text(
                'Données nutritionnelles non disponibles',
                style: TextStyle(
                  color: AppColors.grey2,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getFatValue(Product product) {
    final fat = product.nutritionFacts?.fat;
    if (fat != null && fat.per100g != null) {
      return '${fat.per100g}${fat.unit}';
    }
    return '?';
  }

  String _getSaturatedFatValue(Product product) {
    final sat = product.nutritionFacts?.saturatedFat;
    if (sat != null && sat.per100g != null) {
      return '${sat.per100g}${sat.unit}';
    }
    return '?';
  }

  String _getSugarValue(Product product) {
    final sugar = product.nutritionFacts?.sugar;
    if (sugar != null && sugar.per100g != null) {
      return '${sugar.per100g}${sugar.unit}';
    }
    return '?';
  }

  String _getSaltValue(Product product) {
    final salt = product.nutritionFacts?.salt;
    if (salt != null && salt.per100g != null) {
      return '${salt.per100g}${salt.unit}';
    }
    return '?';
  }
}

class _NutrientBlock extends StatelessWidget {
  const _NutrientBlock({
    required this.label,
    required this.value,
    required this.level,
  });

  final String label;
  final String value;
  final String level;

  String _levelLabel() {
    return switch (level.toLowerCase()) {
      'low' => 'Faible quantité',
      'moderate' => 'Quantité modérée',
      'high' => 'Quantité élevée',
      _ => 'Non déterminé',
    };
  }

  Color _levelColor() {
    return switch (level.toLowerCase()) {
      'low' => AppColors.nutrientLevelLow,
      'moderate' => AppColors.nutrientLevelModerate,
      'high' => AppColors.nutrientLevelHigh,
      _ => AppColors.grey2,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.grey1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.blue,
                fontFamily: 'Avenir',
                fontSize: 14,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: _levelColor(),
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                _levelLabel(),
                style: TextStyle(
                  color: _levelColor(),
                  fontFamily: 'Avenir',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
