// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EffectSetCombatStatus _$EffectSetCombatStatusFromJson(
  Map<String, dynamic> json,
) => EffectSetCombatStatus(
  status: $enumDecode(_$EntityCombatStatusFlagEnumMap, json['status']),
);

Map<String, dynamic> _$EffectSetCombatStatusToJson(
  EffectSetCombatStatus instance,
) => <String, dynamic>{
  'status': _$EntityCombatStatusFlagEnumMap[instance.status]!,
};

const _$EntityCombatStatusFlagEnumMap = {
  EntityCombatStatusFlag.none: 'none',
  EntityCombatStatusFlag.onGround: 'onGround',
  EntityCombatStatusFlag.grappled: 'grappled',
};

EffectClearCombatStatus _$EffectClearCombatStatusFromJson(
  Map<String, dynamic> json,
) => EffectClearCombatStatus(
  status: $enumDecode(_$EntityCombatStatusFlagEnumMap, json['status']),
);

Map<String, dynamic> _$EffectClearCombatStatusToJson(
  EffectClearCombatStatus instance,
) => <String, dynamic>{
  'status': _$EntityCombatStatusFlagEnumMap[instance.status]!,
};
