import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class TripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Transporteur info
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.gray200,
                    backgroundImage: trip.transporterAvatar != null
                        ? NetworkImage(trip.transporterAvatar!)
                        : null,
                    child: trip.transporterAvatar == null
                        ? Text(
                            Helpers.getInitials(trip.transporterName),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              trip.transporterName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (trip.transporterVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                size: 16,
                                color: AppColors.success,
                              ),
                            ],
                          ],
                        ),
                        if (trip.transporterRating != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                trip.transporterRating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Prix
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      Helpers.formatPrice(trip.pricePerKg) + '/kg',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Itinéraire
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DE',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.gray500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trip.from,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.gray400,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'À',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.gray500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trip.to,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Date et capacité
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 14, color: AppColors.gray500),
                  const SizedBox(width: 4),
                  Text(
                    Helpers.formatDate(trip.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: AppColors.gray500),
                  const SizedBox(width: 4),
                  Text(
                    trip.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trip.availableCapacity > 0
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${trip.availableCapacity}kg disponible',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: trip.availableCapacity > 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Barre de capacité
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: trip.capacityPercentage / 100,
                  minHeight: 6,
                  backgroundColor: AppColors.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    trip.capacityPercentage > 80
                        ? AppColors.error
                        : trip.capacityPercentage > 50
                            ? AppColors.warning
                            : AppColors.success,
                  ),
                ),
              ),
              
              // Badges
              if (trip.hasInsurance || trip.isNegotiable) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (trip.hasInsurance)
                      _buildBadge(Icons.shield, 'Assuré'),
                    if (trip.hasInsurance && trip.isNegotiable)
                      const SizedBox(width: 8),
                    if (trip.isNegotiable)
                      _buildBadge(Icons.handshake, 'Négociable'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.gray600),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}
