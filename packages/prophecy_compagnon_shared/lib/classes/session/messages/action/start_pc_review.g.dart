// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_pc_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionStartPlayerCharacterReview _$SessionStartPlayerCharacterReviewFromJson(
  Map<String, dynamic> json,
) =>
    SessionStartPlayerCharacterReview(
        source: json['source'] as String?,
        destination: json['destination'] as String,
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionStartPlayerCharacterReviewToJson(
  SessionStartPlayerCharacterReview instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
};
