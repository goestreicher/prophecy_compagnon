// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_actions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEncounterTurnSelectActions _$SessionEncounterTurnSelectActionsFromJson(
  Map<String, dynamic> json,
) =>
    SessionEncounterTurnSelectActions(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        description: json['description'] as String,
        entityId: json['entity_id'] as String,
        excludedActionUuids:
            (json['excluded_action_uuids'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const <String>[],
        multiselect: json['multiselect'] as bool? ?? false,
        selectRange: json['select_range'] as bool? ?? false,
        allowEmptySelection: json['allow_empty_selection'] as bool? ?? false,
        usableOnly: json['usable_only'] as bool? ?? true,
        showWeakHandAction: json['show_weak_hand_action'] as bool? ?? true,
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionEncounterTurnSelectActionsToJson(
  SessionEncounterTurnSelectActions instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'description': instance.description,
  'entity_id': instance.entityId,
  'excluded_action_uuids': instance.excludedActionUuids,
  'multiselect': instance.multiselect,
  'select_range': instance.selectRange,
  'allow_empty_selection': instance.allowEmptySelection,
  'usable_only': instance.usableOnly,
  'show_weak_hand_action': instance.showWeakHandAction,
};
