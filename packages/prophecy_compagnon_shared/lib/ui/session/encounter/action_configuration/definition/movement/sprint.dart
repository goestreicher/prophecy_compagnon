/*
 * Copyright (C) 2026 Grégory Oestreicher
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/implementations/effect.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/implementations/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effects/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/action/dice_throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/assign_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/get_usable_actions.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/set_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/map/get_movement_path.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/responses/action/movement_path_result.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/action_configuration.dart';
import 'package:prophecy_compagnon_shared/ui/session/evaluate_dice_throw.dart';

class ActionConfigurationMovementSprint extends ActionConfiguration {
  ActionConfigurationMovementSprint();

  @override
  String get name => CombatActionMovementType.sprint.title;

  @override
  IconData get icon => CombatActionMovementType.sprint.icon;

  @override
  Future<void> plan(SessionEncounterEntityAction action) async {
    await guardPlan(action, _doPlan);
  }

  Future<void> _doPlan(SessionEncounterEntityAction action) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      // TODO: display a message
      return;
    }

    var assignedActions = <SessionEncounterEntityAction>[];
    double distanceMultiplier;

    if(action.stage == SessionEncounterEntityActionStage.none) {
      var controllingClient = messageBus.clientControlling(action.entity.id);

      // TODO: request the difficulty from master
      var difficulty = 15;
      var request = DiceThrowRequest(
        type: DiceThrowRequestType.simple,
        context: DiceThrowRequestContext.none,
        difficulty: difficulty,
        base: DiceThrowEntityBaseSkill(
          attribute: Attribute.physique,
          ability: Ability.force,
          skill: Skill.athletisme,
        )
      );

      var diceThrowResponse = await messageBus.publishAndWaitForResponse(
        SessionActionDiceThrowRequestMessage(
          destination: controllingClient,
          entityId: action.entity.id,
          request: request,
        )
      );

      if(diceThrowResponse.status != SessionMessageResponseStatus.accepted) {
        // TODO: display a nice message ?
        return;
      }

      if(diceThrowResponse.data is! DiceThrowResult) {
        // TODO: display a nice message ?
        return;
      }

      var bundle = EntityThrowBundle(
        entity: action.entity,
        request: request,
        result: diceThrowResponse.data,
      );

      // TODO: manage duration
      var evaluation = evaluateDiceThrow(bundle);
      if(evaluation.criticalType == DiceThrowResultType.criticalFail) {
        var setResponse = await messageBus.publishAndWaitForResponse(
          SessionEncounterTurnSetCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: action.uuid,
            combatAction: CombatActionEffect(
              entityId: action.entity.id,
              rank: action.rank,
              effects: [
                EffectSetCombatStatus(
                  status: EntityCombatStatusFlag.onGround,
                )
              ]
            )
          )
        );

        if(setResponse.status != SessionMessageResponseStatus.accepted) {
          // TODO: display a message
          return;
        }

        return;
      }
      else if(evaluation.resultType == DiceThrowResultType.fail) {
        distanceMultiplier = 3.0;
      }
      else {
        distanceMultiplier = 5.0;
      }

      var usableActionsResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnGetUsableActions(
          destination: SessionMessage.masterIdentifier,
          entityId: action.entity.id,
          excludedActionUuids: [action.uuid],
        )
      );

      if(usableActionsResponse.status != SessionMessageResponseStatus.accepted) {
        // TODO: display a nice message ?
        return;
      }

      if(usableActionsResponse.data != null) {
        var actions = (usableActionsResponse.data as List<SessionEncounterEntityAction>)
            .where((SessionEncounterEntityAction a) => a.canBeUsedFor(CombatActionType.movement));

        for(var a in actions) {
          var assignResponse = await messageBus.publishAndWaitForResponse(
            SessionEncounterTurnAssignCombatActionMessage(
              destination: SessionMessage.masterIdentifier,
              actionUuid: a.uuid,
              combatAction: CombatActionAssignedMovement(
                entityId: a.entity.id,
                rank: a.rank,
                movementType: CombatActionMovementType.run,
                distanceMultiplier: distanceMultiplier,
              ),
            )
          );

          if(assignResponse.status != SessionMessageResponseStatus.accepted) {
            // TODO: display a message
            continue;
          }

          assignedActions.add(a);
        }
      }
    }
    else {
      distanceMultiplier = (action.combatAction! as CombatActionMovement).distanceMultiplier;
    }

    var controllingClient = messageBus.clientControlling(action.entity.id);

    var pathResponse = await messageBus.publishAndWaitForResponse(
      SessionMapGetMovementPath(
        destination: controllingClient,
        entityId: action.entity.id,
        distanceMultiplier: distanceMultiplier,
        waitResponseTimeout: 60,
      ),
    );

    var (cancelAction, cancelReason) = mustCancelAction(pathResponse);

    if(cancelAction) {
      messageBus.publish(
        SessionMapCancelGetMovementPath(
          destination: SessionMessage.masterIdentifier,
          entityId: action.entity.id,
          cancelReason: cancelReason,
        )
      );

      for(var a in assignedActions) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: a.uuid,
          )
        );
      }

      return;
    }

    var r = (pathResponse.data as SessionMovementPathResult?);
    if(r == null || r.path.isEmpty || r.path.length == 0.0) {
      for(var a in assignedActions) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: a.uuid,
          )
        );
      }

      // TODO: display a nice message?
      return;
    }

    var setResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSetCombatActionMessage(
        destination: SessionMessage.masterIdentifier,
        actionUuid: action.uuid,
        combatAction: CombatActionMovement(
          movementType: CombatActionMovementType.run,
          distanceMultiplier: distanceMultiplier,
          rank: action.rank,
          mapId: r.mapId,
          entityId: action.entity.id,
          path: r.path,
        )
      )
    );

    if(setResponse.status != SessionMessageResponseStatus.accepted) {
      for(var a in assignedActions) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: a.uuid,
          )
        );
      }

      // TODO: display a message
      return;
    }
  }
}