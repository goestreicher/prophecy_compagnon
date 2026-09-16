// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatActionAssignedMovement _$CombatActionAssignedMovementFromJson(
  Map<String, dynamic> json,
) => CombatActionAssignedMovement(
  entityId: json['entity_id'] as String,
  rank: (json['rank'] as num).toInt(),
  movementType: $enumDecode(
    _$CombatActionMovementTypeEnumMap,
    json['movement_type'],
  ),
  interpolate: json['interpolate'] as bool? ?? false,
  distanceMultiplier: (json['distance_multiplier'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$CombatActionAssignedMovementToJson(
  CombatActionAssignedMovement instance,
) => <String, dynamic>{
  'entity_id': instance.entityId,
  'rank': instance.rank,
  'interpolate': instance.interpolate,
  'movement_type': _$CombatActionMovementTypeEnumMap[instance.movementType]!,
  'distance_multiplier': instance.distanceMultiplier,
};

const _$CombatActionMovementTypeEnumMap = {
  CombatActionMovementType.simple: 'simple',
  CombatActionMovementType.run: 'run',
  CombatActionMovementType.sprint: 'sprint',
  CombatActionMovementType.getUp: 'getUp',
};

CombatActionMovement _$CombatActionMovementFromJson(
  Map<String, dynamic> json,
) => CombatActionMovement(
  entityId: json['entity_id'] as String,
  rank: (json['rank'] as num).toInt(),
  movementType: $enumDecode(
    _$CombatActionMovementTypeEnumMap,
    json['movement_type'],
  ),
  distanceMultiplier: (json['distance_multiplier'] as num?)?.toDouble() ?? 1.0,
  mapId: json['map_id'] as String,
  path: MovementPath.fromJson(json['path'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CombatActionMovementToJson(
  CombatActionMovement instance,
) => <String, dynamic>{
  'entity_id': instance.entityId,
  'rank': instance.rank,
  'movement_type': _$CombatActionMovementTypeEnumMap[instance.movementType]!,
  'distance_multiplier': instance.distanceMultiplier,
  'map_id': instance.mapId,
  'path': instance.path.toJson(),
};
