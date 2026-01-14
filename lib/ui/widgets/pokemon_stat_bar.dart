import 'package:flutter/material.dart';
import 'package:flutter_pokedex/domain/models/pokemon_stat.dart';

class PokemonStatBar extends StatelessWidget {
  const PokemonStatBar({required this.stat, super.key});

  final PokemonStat stat;

  @override
  Widget build(BuildContext context) {
    const maxStat = 255;
    final percentage = (stat.baseStat / maxStat).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              stat.stat.displayName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatColor(percentage),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              stat.baseStat.toString(),
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatColor(double percentage) {
    if (percentage >= 0.7) {
      return Colors.green;
    } else if (percentage >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
