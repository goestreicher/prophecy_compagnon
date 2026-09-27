// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_property_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEntitySetPropertyMessage _$SessionEntitySetPropertyMessageFromJson(
  Map<String, dynamic> json,
) =>
    SessionEntitySetPropertyMessage(
        source: json['source'] as String?,
        broadcastIncludesSelf:
            json['broadcast_includes_self'] as bool? ?? false,
        entityId: json['entity_id'] as String,
        property: $enumDecode(_$EntityMessagePropertyEnumMap, json['property']),
        value: json['value'],
      )
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt();

Map<String, dynamic> _$SessionEntitySetPropertyMessageToJson(
  SessionEntitySetPropertyMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'property': _$EntityMessagePropertyEnumMap[instance.property]!,
  'value': instance.value,
};

const _$EntityMessagePropertyEnumMap = {
  EntityMessageProperty.useLuckPoints: 'useLuckPoints',
  EntityMessageProperty.gainLuckPoints: 'gainLuckPoints',
  EntityMessageProperty.useProficiencyPoints: 'useProficiencyPoints',
  EntityMessageProperty.gainProficiencyPoints: 'gainProficiencyPoints',
};
