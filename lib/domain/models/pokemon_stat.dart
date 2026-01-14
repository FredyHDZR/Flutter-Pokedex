import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_stat.freezed.dart';
part 'pokemon_stat.g.dart';

@freezed
class PokemonStat with _$PokemonStat {
  const factory PokemonStat({
    required int baseStat,
    required int effort,
    required StatInfo stat,
  }) = _PokemonStat;

  factory PokemonStat.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatFromJson(json);
}

@freezed
class StatInfo with _$StatInfo {
  const factory StatInfo({
    required String name,
    required String url,
  }) = _StatInfo;

  factory StatInfo.fromJson(Map<String, dynamic> json) =>
      _$StatInfoFromJson(json);
}

extension StatInfoExtension on StatInfo {
  String get displayName {
    switch (name) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Atk';
      case 'special-defense':
        return 'Sp. Def';
      case 'speed':
        return 'Speed';
      default:
        return name.toUpperCase();
    }
  }
}
