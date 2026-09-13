// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EffectSetHealthStatus _$EffectSetHealthStatusFromJson(
  Map<String, dynamic> json,
) => EffectSetHealthStatus(
  status: $enumDecode(_$EntityHealthStatusFlagEnumMap, json['status']),
);

Map<String, dynamic> _$EffectSetHealthStatusToJson(
  EffectSetHealthStatus instance,
) => <String, dynamic>{
  'status': _$EntityHealthStatusFlagEnumMap[instance.status]!,
};

const _$EntityHealthStatusFlagEnumMap = {
  EntityHealthStatusFlag.none: 'none',
  EntityHealthStatusFlag.injured: 'injured',
  EntityHealthStatusFlag.dead: 'dead',
  EntityHealthStatusFlag.stunned: 'stunned',
  EntityHealthStatusFlag.unconscious: 'unconscious',
};

EffectClearHealthStatus _$EffectClearHealthStatusFromJson(
  Map<String, dynamic> json,
) => EffectClearHealthStatus(
  status: $enumDecode(_$EntityHealthStatusFlagEnumMap, json['status']),
);

Map<String, dynamic> _$EffectClearHealthStatusToJson(
  EffectClearHealthStatus instance,
) => <String, dynamic>{
  'status': _$EntityHealthStatusFlagEnumMap[instance.status]!,
};
