import 'package:flutter/material.dart';
import '../models/health_models.dart';

class SourceBadge extends StatelessWidget {
  final HealthDataSource source;
  final bool compact;

  const SourceBadge({
    super.key,
    required this.source,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = source.color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            source.icon,
            size: compact ? 11 : 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            compact
                ? (source == HealthDataSource.appleHealth
                    ? 'Apple Health'
                    : source == HealthDataSource.googleFit
                        ? 'Google Fit'
                        : source == HealthDataSource.manualInput
                            ? 'Manual'
                            : 'AI Est.')
                : source.label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

