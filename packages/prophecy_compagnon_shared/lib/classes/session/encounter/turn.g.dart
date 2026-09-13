// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEncounterTurn _$SessionEncounterTurnFromJson(
  Map<String, dynamic> json,
) => SessionEncounterTurn(
  actions: (json['actions'] as List<dynamic>)
      .map(
        (e) => SessionEncounterEntityAction.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
)..currentRank = (json['current_rank'] as num).toInt();

Map<String, dynamic> _$SessionEncounterTurnToJson(
  SessionEncounterTurn instance,
) => <String, dynamic>{
  'actions': instance.actions.map((e) => e.toJson()).toList(),
  'current_rank': instance.currentRank,
};
