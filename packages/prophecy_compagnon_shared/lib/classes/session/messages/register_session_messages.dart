// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/session/messages/session_message.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/action/dice_throw_request.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/action/start_pc_review.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/action_planning.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/assign_combat_action.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/delay_action.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/get_usable_actions.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/select_actions.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/set_combat_action.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/management/request_master.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/map/get_movement_path.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/set_state/board.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/set_state/ticker.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/status/entity_position_status.dart";
import "package:prophecy_compagnon_shared/classes/session/messages/status/entity_property_status.dart";

void registerSessionMessages() {
  SessionMessage.registerSessionMessageJsonFactory(
    "SessionActionDiceThrowRequestMessage",
    (Map<String, dynamic> json) => SessionActionDiceThrowRequestMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionStartPlayerCharacterReview",
    (Map<String, dynamic> json) => SessionStartPlayerCharacterReview.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEncounterTurnActionPlanningStart",
    (Map<String, dynamic> json) => SessionEncounterTurnActionPlanningStart.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEncounterTurnActionPlanningEnd",
    (Map<String, dynamic> json) => SessionEncounterTurnActionPlanningEnd.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEncounterTurnAssignCombatActionMessage",
    (Map<String, dynamic> json) => SessionEncounterTurnAssignCombatActionMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEncounterTurnUnassignCombatActionMessage",
    (Map<String, dynamic> json) => SessionEncounterTurnUnassignCombatActionMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEncounterTurnDelayActionMessage",
    (Map<String, dynamic> json) => SessionEncounterTurnDelayActionMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEncounterTurnGetUsableActions",
    (Map<String, dynamic> json) => SessionEncounterTurnGetUsableActions.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEncounterTurnSelectActions",
    (Map<String, dynamic> json) => SessionEncounterTurnSelectActions.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEncounterTurnSetCombatActionMessage",
    (Map<String, dynamic> json) => SessionEncounterTurnSetCombatActionMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionRequestMaster",
    (Map<String, dynamic> json) => SessionRequestMaster.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionMapGetMovementPath",
    (Map<String, dynamic> json) => SessionMapGetMovementPath.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionMapCancelGetMovementPath",
    (Map<String, dynamic> json) => SessionMapCancelGetMovementPath.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionMessageResponse",
    (Map<String, dynamic> json) => SessionMessageResponse.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionSetStateBoardPush",
    (Map<String, dynamic> json) => SessionSetStateBoardPush.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionSetStateBoardSelect",
    (Map<String, dynamic> json) => SessionSetStateBoardSelect.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionSetStateBoardRemove",
    (Map<String, dynamic> json) => SessionSetStateBoardRemove.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionTickerEventMessage",
    (Map<String, dynamic> json) => SessionTickerEventMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEntityAddEffectMessage",
    (Map<String, dynamic> json) => SessionEntityAddEffectMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEntityUnapplyEffectMessage",
    (Map<String, dynamic> json) => SessionEntityUnapplyEffectMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEntityPositionStatusMessage",
    (Map<String, dynamic> json) => SessionEntityPositionStatusMessage.fromJson(json),
  );

  SessionMessage.registerSessionMessageJsonFactory(
    "SessionEntitySetPropertyMessage",
    (Map<String, dynamic> json) => SessionEntitySetPropertyMessage.fromJson(json),
  );

}
