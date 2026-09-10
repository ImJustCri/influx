import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/switch/Fuel/price_tile.dart';
import '../../../models/switch/station_model.dart';

class StationCard extends StatelessWidget {
  final Station station;
  final String petrol;
  final String diesel;
  final bool isBestPrice;

  const StationCard({
    super.key,
    required this.station,
    required this.petrol,
    required this.diesel,
    required this.isBestPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBestPrice ? AppColors.btnBackground : AppColors.containerBorder,
          width: isBestPrice ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.bandiera,
                      style: AppTypography.containerTitle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      station.nome,
                      style: AppTypography.containerBody,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.backgroundAccent.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(128),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Text(
                  station.pumpType,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.whiteDim,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppContainer(
            padding: const EdgeInsets.all(8),
            borderRadius: 16,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.map_pin, size: 16, color: AppColors.containerBorder),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        station.indirizzo,
                        style: AppTypography.containerBody,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.landmark, size: 16, color: AppColors.containerBorder),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${station.comune} (${station.provincia})",
                        style: AppTypography.containerBody,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.containerBorder),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PriceTile(
                  label: "Benzina",
                  value: petrol,
                  highlight: isBestPrice,
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: AppColors.containerBorder,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: PriceTile(
                  label: "Diesel",
                  value: diesel,
                  highlight: false,
                ),
              ),
            ],
          ),
          if (isBestPrice) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(LucideIcons.badge_check, size: 14, color: AppColors.btnBackground),
                const SizedBox(width: 6),
                const Text(
                  "Prezzo migliore in zona",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.btnBackground,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}