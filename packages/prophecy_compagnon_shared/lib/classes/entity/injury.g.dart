// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injury.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InflictedInjuryProperties _$InflictedInjuryPropertiesFromJson(
  Map<String, dynamic> json,
) => InflictedInjuryProperties(
  canUseHealingMethod: json['can_use_healing_method'] as bool? ?? true,
  healingMethod: $enumDecodeNullable(
    _$InjuryHealingMethodEnumMap,
    json['healing_method'],
  ),
);

Map<String, dynamic> _$InflictedInjuryPropertiesToJson(
  InflictedInjuryProperties instance,
) => <String, dynamic>{
  'can_use_healing_method': instance.canUseHealingMethod,
  'healing_method': _$InjuryHealingMethodEnumMap[instance.healingMethod],
};

const _$InjuryHealingMethodEnumMap = {
  InjuryHealingMethod.firstHelp: 'firstHelp',
  InjuryHealingMethod.medicine: 'medicine',
  InjuryHealingMethod.chirurgy: 'chirurgy',
};

InflictedInjury _$InflictedInjuryFromJson(Map<String, dynamic> json) =>
    InflictedInjury(
      remainingHealingDays: (json['remaining_healing_days'] as num).toInt(),
      properties: json['properties'] == null
          ? null
          : InflictedInjuryProperties.fromJson(
              json['properties'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$InflictedInjuryToJson(InflictedInjury instance) =>
    <String, dynamic>{
      'remaining_healing_days': instance.remainingHealingDays,
      'properties': instance.properties.toJson(),
    };

InjuryLevel _$InjuryLevelFromJson(Map<String, dynamic> json) => InjuryLevel(
  type: $enumDecode(_$InjuryEnumMap, json['type']),
  start: (json['start'] as num).toInt(),
  end: (json['end'] as num).toInt(),
  capacity: (json['capacity'] as num).toInt(),
);

Map<String, dynamic> _$InjuryLevelToJson(InjuryLevel instance) =>
    <String, dynamic>{
      'type': _$InjuryEnumMap[instance.type]!,
      'start': instance.start,
      'end': instance.end,
      'capacity': instance.capacity,
    };

const _$InjuryEnumMap = {
  Injury.ignore: 'ignore',
  Injury.scratch: 'scratch',
  Injury.injured: 'injured',
  Injury.light: 'light',
  Injury.grave: 'grave',
  Injury.fatal: 'fatal',
  Injury.death: 'death',
};

EntityInjuries _$EntityInjuriesFromJson(Map<String, dynamic> json) =>
    EntityInjuries(
      manager: InjuryManager.fromJson(json['manager'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EntityInjuriesToJson(EntityInjuries instance) =>
    <String, dynamic>{'manager': instance.manager.toJson()};
