// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionRequestMaster _$SessionRequestMasterFromJson(
  Map<String, dynamic> json,
) =>
    SessionRequestMaster(
        source: json['source'] as String?,
        runUuid: json['run_uuid'] as String,
        waitResponseTimeout: (json['wait_response_timeout'] as num?)?.toInt(),
      )
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionRequestMasterToJson(
  SessionRequestMaster instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'run_uuid': instance.runUuid,
};
