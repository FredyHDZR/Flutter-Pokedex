import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_type.freezed.dart';
part 'pokemon_type.g.dart';

@freezed
class PokemonType with _$PokemonType {
  const factory PokemonType({
    required int slot,
    required TypeInfo type,
  }) = _PokemonType;

  factory PokemonType.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeFromJson(json);
}

@freezed
class TypeInfo with _$TypeInfo {
  const factory TypeInfo({
    required String name,
    required String url,
  }) = _TypeInfo;

  factory TypeInfo.fromJson(Map<String, dynamic> json) =>
      _$TypeInfoFromJson(json);
}
