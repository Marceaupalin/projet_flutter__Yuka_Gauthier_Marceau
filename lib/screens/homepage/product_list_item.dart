// Removed cached_network_image import
import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    super.key,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.nutriScore,
    this.onTap,
  });

  final String name;
  final String brand;
  final String imageUrl;
  final String nutriScore;
  final VoidCallback? onTap;

  Color _nutriScoreColor(String score) {
    return switch (score.toUpperCase()) {
      'A' => AppColors.nutriscoreA,
      'B' => AppColors.nutriscoreB,
      'C' => AppColors.nutriscoreC,
      'D' => AppColors.nutriscoreD,
      'E' => AppColors.nutriscoreE,
      _ => AppColors.grey2,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // Total height to accommodate the image overlap
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // White Card Background
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100, // Card is 100px high, leaving 20px overlap at the top
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 110.0, // Space for the overhanging image
                    top: 12.0,
                    bottom: 12.0,
                    right: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name.isNotEmpty ? name : 'Produit inconnu',
                        style: const TextStyle(
                          color: AppColors.blue,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (brand.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          brand,
                          style: const TextStyle(
                            color: AppColors.grey3,
                            fontFamily: 'Avenir',
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Spacer(),
                      if (nutriScore.isNotEmpty && nutriScore != 'unknown') ...[
                        Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: _nutriScoreColor(nutriScore),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nutriscore : ${nutriScore.toUpperCase()}',
                              style: const TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            
            // Overlapping Image
            Positioned(
              left: 16,
              top: 0, // Starts at the very top of the Stack (y=0)
              bottom: 12, // overall height 120, offset by 12 from bottom to match mockup
              width: 85,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: AppColors.grey1,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        )
                      : _buildPlaceholder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.grey1,
      child: const Center(
        child: Icon(Icons.image_not_supported, color: AppColors.grey2),
      ),
    );
  }
}
