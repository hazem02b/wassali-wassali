import 'package:flutter/material.dart';
import '../models/trip.dart';
import 'package:intl/intl.dart';

/// Card pour afficher un trajet
class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy', 'fr_FR');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trip.route,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Date et prix
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(trip.departureDate),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${trip.pricePerKg.toStringAsFixed(2)} €/kg',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Poids disponible
              Row(
                children: [
                  const Icon(Icons.shopping_bag, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Disponible: ${trip.availableWeight.toStringAsFixed(0)} kg',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

              // Transporteur (si disponible)
              if (trip.transporter != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      child: Text(
                        trip.transporter!.firstName[0],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip.transporter!.fullName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    if (trip.transporter!.rating != null) ...[
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        trip.transporter!.rating!.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
