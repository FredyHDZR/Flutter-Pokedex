import 'package:flutter_pokedex/domain/models/pokemon_ability.dart';
import 'package:flutter_pokedex/domain/models/pokemon_sprites.dart';
import 'package:flutter_pokedex/domain/models/pokemon_stat.dart';
import 'package:flutter_pokedex/domain/models/pokemon_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail.freezed.dart';
part 'pokemon_detail.g.dart';

@freezed
class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    required int id,
    required String name,
    required int height,
    required int weight,
    @JsonKey(name: 'base_experience') required int baseExperience,
    required List<PokemonType> types,
    required PokemonSprites sprites,
    required List<PokemonStat> stats,
    required List<PokemonAbility> abilities,
  }) = _PokemonDetail;

  factory PokemonDetail.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailFromJson(json);
}

extension PokemonDetailExtension on PokemonDetail {
  double get heightInMeters => height / 10.0;
  double get weightInKilograms => weight / 10.0;
}
