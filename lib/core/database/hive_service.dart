import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String pokemonBoxName = 'pokemons';
  static const String pokemonDetailBoxName = 'pokemon_details';
  static const String cacheMetadataBoxName = 'cache_metadata';

  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox(pokemonBoxName);
    await Hive.openBox(pokemonDetailBoxName);
    await Hive.openBox(cacheMetadataBoxName);
  }

  static Box get pokemonBox => Hive.box(pokemonBoxName);
  static Box get pokemonDetailBox => Hive.box(pokemonDetailBoxName);
  static Box get metadataBox => Hive.box(cacheMetadataBoxName);
}

