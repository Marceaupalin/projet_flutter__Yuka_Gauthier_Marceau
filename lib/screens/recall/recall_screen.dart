// Removed cached_network_image import
import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:share_plus/share_plus.dart';

class RecallScreen extends StatelessWidget {
  const RecallScreen({super.key, required this.recallData});

  final Map<String, dynamic> recallData;

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = recallData['liens_vers_les_images'] as String?;
    final String? distributors = recallData['nom_de_marque_du_produit'] as String?;
    final String? zone = recallData['zone_geographique_de_vente'] as String?;
    final String? motif = recallData['motif_du_rappel'] as String?;
    final String? risques = recallData['risques_encourus_par_le_consommateur'] as String?;
    final String? link = recallData['lien_vers_la_fiche_rappel'] as String?;
    final String? dateDebut = recallData['date_debut_fin_de_commercialisation'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rappel produit',
          style: TextStyle(
            color: AppColors.blue,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (link != null && link.isNotEmpty)
            IconButton(
              icon: Icon(Icons.share, color: AppColors.blue),
              onPressed: () {
                Share.share(link);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: AppColors.grey1,
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                  ),
                ),
              ),
            if (dateDebut != null && dateDebut.isNotEmpty)
              _buildInfoBlock(
                title: 'Dates de commercialisation',
                content: dateDebut,
              ),
            if (distributors != null && distributors.isNotEmpty)
              _buildInfoBlock(
                title: 'Distributeurs',
                content: distributors,
              ),
            if (zone != null && zone.isNotEmpty)
              _buildInfoBlock(
                title: 'Zone géographique',
                content: zone,
              ),
            if (motif != null && motif.isNotEmpty)
              _buildInfoBlock(
                title: 'Motif du rappel',
                content: motif,
              ),
            if (risques != null && risques.isNotEmpty)
              _buildInfoBlock(
                title: 'Risques encourus',
                content: risques,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: AppColors.blue,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blue,
              fontFamily: 'Avenir',
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
