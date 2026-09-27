// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionMessageResponse _$SessionMessageResponseFromJson(
  Map<String, dynamic> json,
) =>
    SessionMessageResponse(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        hasResponse: json['has_response'] as bool? ?? false,
        ack: json['ack'] as String,
        status: $enumDecode(
          _$SessionMessageResponseStatusEnumMap,
          json['status'],
        ),
        statusMessage: json['status_message'] as String?,
        data: json['data'],
      )
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionMessageResponseToJson(
  SessionMessageResponse instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'ack': instance.ack,
  'status': _$SessionMessageResponseStatusEnumMap[instance.status]!,
  'status_message': instance.statusMessage,
  'data': instance.data,
};

const _$SessionMessageResponseStatusEnumMap = {
  SessionMessageResponseStatus.accepted: 'accepted',
  SessionMessageResponseStatus.cancelled: 'cancelled',
  SessionMessageResponseStatus.rejected: 'rejected',
  SessionMessageResponseStatus.error: 'error',
  SessionMessageResponseStatus.timeout: 'timeout',
};
