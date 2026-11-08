// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatActionDefenseDodge _$CombatActionDefenseDodgeFromJson(
  Map<String, dynamic> json,
) => CombatActionDefenseDodge(
  entityId: json['entity_id'] as String,
  rank: (json['rank'] as num).toInt(),
);

Map<String, dynamic> _$CombatActionDefenseDodgeToJson(
  CombatActionDefenseDodge instance,
) => <String, dynamic>{'entity_id': instance.entityId, 'rank': instance.rank};

CombatActionDefenseParryShield _$CombatActionDefenseParryShieldFromJson(
  Map<String, dynamic> json,
) => CombatActionDefenseParryShield(
  entityId: json['entity_id'] as String,
  rank: (json['rank'] as num).toInt(),
  shield: Shield.fromJson(json['shield'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CombatActionDefenseParryShieldToJson(
  CombatActionDefenseParryShield instance,
) => <String, dynamic>{
  'entity_id': instance.entityId,
  'rank': instance.rank,
  'shield': instance.shield.toJson(),
};

CombatActionDefenseParryWeapon _$CombatActionDefenseParryWeaponFromJson(
  Map<String, dynamic> json,
) => CombatActionDefenseParryWeapon(
  entityId: json['entity_id'] as String,
  rank: (json['rank'] as num).toInt(),
  weapon: Weapon.fromJson(json['weapon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CombatActionDefenseParryWeaponToJson(
  CombatActionDefenseParryWeapon instance,
) => <String, dynamic>{
  'entity_id': instance.entityId,
  'rank': instance.rank,
  'weapon': instance.weapon.toJson(),
};
