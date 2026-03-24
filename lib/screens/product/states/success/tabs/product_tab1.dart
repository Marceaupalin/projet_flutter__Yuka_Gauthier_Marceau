import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Ingrédients',
            child: _buildIngredients(product),
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Substances allergènes',
            child: _buildAllergens(product),
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Additifs',
            child: _buildAdditives(product),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.blue,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(height: 1),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildIngredients(Product product) {
    final ingredients = product.ingredients;
    if (ingredients == null || ingredients.isEmpty) {
      return Text(
        'Aucune donnée disponible',
        style: TextStyle(color: AppColors.grey2, fontFamily: 'Avenir'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients.map((ingredient) {
        final parts = _parseIngredient(ingredient);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  parts['name']!,
                  style: TextStyle(
                    color: AppColors.blue,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (parts['detail']!.isNotEmpty)
                Expanded(
                  child: Text(
                    parts['detail']!,
                    style: TextStyle(
                      color: AppColors.grey3,
                      fontFamily: 'Avenir',
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, String> _parseIngredient(String ingredient) {
    final regex = RegExp(r'^([^(]+?)(\s*\(.*\))?$');
    final match = regex.firstMatch(ingredient);
    if (match != null) {
      return {
        'name': match.group(1)?.trim() ?? ingredient,
        'detail': match.group(2)?.trim() ?? '',
      };
    }
    return {'name': ingredient, 'detail': ''};
  }

  Widget _buildAllergens(Product product) {
    final allergens = product.allergens;
    if (allergens == null || allergens.isEmpty) {
      return Text(
        'Aucune',
        style: TextStyle(color: AppColors.grey2, fontFamily: 'Avenir'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: allergens.map((allergen) {
        return Text(
          allergen,
          style: TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdditives(Product product) {
    final additives = product.additives;
    if (additives == null || additives.isEmpty) {
      return Text(
        'Aucune',
        style: TextStyle(color: AppColors.grey2, fontFamily: 'Avenir'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: additives.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            '${entry.key.toUpperCase()} - ${entry.value}',
            style: TextStyle(
              color: AppColors.blue,
              fontFamily: 'Avenir',
            ),
          ),
        );
      }).toList(),
    );
  }
}
