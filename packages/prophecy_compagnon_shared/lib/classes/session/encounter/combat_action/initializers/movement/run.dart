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
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/action_initializer.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/assign_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/get_usable_actions.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/set_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/map/get_movement_path.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/responses/action/movement_path_result.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';

class ActionInitializerMovementRun extends ActionInitializer {
  ActionInitializerMovementRun();

  @override
  String get name => CombatActionMovementType.run.title;

  @override
  IconData get icon => CombatActionMovementType.run.icon;

  @override
  Future<void> plan(BuildContext context, SessionEncounterEntityAction action) async {
    await guardPlan(context, action, _doPlan);
  }

  Future<void> _doPlan(BuildContext context, SessionEncounterEntityAction action) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      throw(
        SessionMessageBusClientException(
          "Aucune instance du bus de message n'a été trouvée, impossible de planifier l'action",
        )
      );
    }

    var assignedActions = <SessionEncounterEntityAction>[];

    if(action.stage == SessionEncounterEntityActionStage.none) {
      var usableActionsResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnGetUsableActions(
          destination: SessionMessage.masterIdentifier,
          entityId: action.entity.id,
          excludedActionUuids: [action.uuid],
        )
      );

      if(usableActionsResponse.status != SessionMessageResponseStatus.accepted) {
        throw(
          ActionInitializerException(
            title: "Demande d'actions utilisables non acceptée",
            message:
              "La demande d'actions utilisables n'a pas été acceptée (statut "
              "${usableActionsResponse.status}), impossible de planifier l'action"
          )
        );
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
                distanceMultiplier: 2.0,
              ),
            )
          );

          if(assignResponse.status != SessionMessageResponseStatus.accepted) {
            for(var aa in assignedActions) {
              messageBus.publish(
                SessionEncounterTurnUnassignCombatActionMessage(
                  destination: SessionMessage.masterIdentifier,
                  actionUuid: aa.uuid,
                )
              );
            }

            throw(
              ActionInitializerException(
                title: "Demande d'assignation d'action non acceptée",
                message:
                  "La demande d'assignation pour l'action de rang ${a.rank} n'a "
                  "pas été acceptée (statut ${assignResponse.status}), "
                  "impossible de planifier l'action"
              )
            );
          }

          assignedActions.add(a);
        }
      }
    }

    var controllingClient = messageBus.clientControlling(action.entity.id);

    var pathResponse = await messageBus.publishAndWaitForResponse(
      SessionMapGetMovementPath(
        destination: controllingClient,
        entityId: action.entity.id,
        distanceMultiplier: 2.0,
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

      throw(
        ActionInitializerException(
          title: "Déplacement invalide retourné",
          message:
            "Un chemin invalide ou vide a été retourné, "
            "impossible de planifier l'action"
        )
      );
    }

    var setResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSetCombatActionMessage(
        destination: SessionMessage.masterIdentifier,
        actionUuid: action.uuid,
        combatAction: CombatActionMovement(
          movementType: CombatActionMovementType.run,
          distanceMultiplier: 2.0,
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

      throw(
        ActionInitializerException(
          title: "Affectation de l'action non acceptée",
          message:
            "La demande d'affectation de l'action n'a pas été acceptée (statut "
            "${setResponse.status}), impossible de planifier l'action"
        )
      );
    }
  }
}