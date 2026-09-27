// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_effect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEntityAddEffectMessage _$SessionEntityAddEffectMessageFromJson(
  Map<String, dynamic> json,
) =>
    SessionEntityAddEffectMessage(
        source: json['source'] as String?,
        broadcastIncludesSelf:
            json['broadcast_includes_self'] as bool? ?? false,
        entityId: json['entity_id'] as String,
        effect: EntityEffect.fromJson(json['effect'] as Map<String, dynamic>),
      )
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt();

Map<String, dynamic> _$SessionEntityAddEffectMessageToJson(
  SessionEntityAddEffectMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'effect': instance.effect.toJson(),
};

SessionEntityUnapplyEffectMessage _$SessionEntityUnapplyEffectMessageFromJson(
  Map<String, dynamic> json,
) =>
    SessionEntityUnapplyEffectMessage(
        source: json['source'] as String?,
        broadcastIncludesSelf:
            json['broadcast_includes_self'] as bool? ?? false,
        entityId: json['entity_id'] as String,
        effectId: json['effect_id'] as String,
      )
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt();

Map<String, dynamic> _$SessionEntityUnapplyEffectMessageToJson(
  SessionEntityUnapplyEffectMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'effect_id': instance.effectId,
};
