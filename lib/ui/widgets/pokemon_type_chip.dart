import 'package:flutter/material.dart';
import '../../domain/models/pokemon_type.dart';

class PokemonTypeChip extends StatelessWidget {
  final PokemonType pokemonType;

  const PokemonTypeChip({required this.pokemonType});

  Color _getTypeColor(String typeName) {
    switch (typeName.toLowerCase()) {
      case 'normal':
        return Colors.grey;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.yellow.shade700;
      case 'grass':
        return Colors.green;
      case 'ice':
        return Colors.cyan;
      case 'fighting':
        return Colors.brown;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown.shade300;
      case 'flying':
        return Colors.lightBlue.shade300;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.green.shade400;
      case 'rock':
        return Colors.grey.shade600;
      case 'ghost':
        return Colors.purple.shade700;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.grey.shade800;
      case 'steel':
        return Colors.grey.shade500;
      case 'fairy':
        return Colors.pink.shade200;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeName = pokemonType.type.name;
    final color = _getTypeColor(typeName);

    return Chip(
      label: Text(
        typeName.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

