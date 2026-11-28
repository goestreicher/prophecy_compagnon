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
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/set_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/map/get_movement_path.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/responses/action/movement_path_result.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';

class ActionInitializerMovementSimple extends ActionInitializer {
  ActionInitializerMovementSimple();

  @override
  String get name => CombatActionMovementType.simple.title;

  @override
  IconData get icon => CombatActionMovementType.simple.icon;

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

    var controllingClient = messageBus.clientControlling(action.entity.id);

    var pathResponse = await messageBus.publishAndWaitForResponse(
      SessionMapGetMovementPath(
        destination: controllingClient,
        entityId: action.entity.id,
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

      return;
    }

    var r = (pathResponse.data as SessionMovementPathResult?);
    if(r == null || r.path.isEmpty || r.path.length == 0.0) {
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
          movementType: CombatActionMovementType.simple,
          rank: action.rank,
          mapId: r.mapId,
          entityId: action.entity.id,
          path: r.path,
        )
      )
    );

    if(setResponse.status != SessionMessageResponseStatus.accepted) {
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