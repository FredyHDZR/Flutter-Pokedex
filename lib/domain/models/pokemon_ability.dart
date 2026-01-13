import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_ability.freezed.dart';
part 'pokemon_ability.g.dart';

@freezed
class PokemonAbility with _$PokemonAbility {
  const factory PokemonAbility({
    required AbilityInfo ability,
    @JsonKey(name: 'is_hidden') required bool isHidden,
    required int slot,
  }) = _PokemonAbility;

  factory PokemonAbility.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilityFromJson(json);
}

@freezed
class AbilityInfo with _$AbilityInfo {
  const factory AbilityInfo({
    required String name,
    required String url,
  }) = _AbilityInfo;

  factory AbilityInfo.fromJson(Map<String, dynamic> json) =>
      _$AbilityInfoFromJson(json);
}

