// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionTickerEventMessage _$SessionTickerEventMessageFromJson(
  Map<String, dynamic> json,
) =>
    SessionTickerEventMessage(
        event: TickerEvent.fromJson(json['event'] as Map<String, dynamic>),
      )
      ..source = json['source'] as String?
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionTickerEventMessageToJson(
  SessionTickerEventMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'event': instance.event.toJson(),
};
