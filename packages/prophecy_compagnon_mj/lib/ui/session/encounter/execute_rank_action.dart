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

import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_position_status.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_property_status.dart';

void executeRankAction(CombatAction action) {
  switch(action.type) {
    case CombatActionType.attack:
      _executeAttackAction(action as CombatActionAttack);
    case CombatActionType.defense:
      // Nothing to do for actions used for defense, they've already been resolved
      break;
    case CombatActionType.effect:
      // Nothing to do here, effects are managed below
      break;
    case CombatActionType.movement:
      _executeMovementAction(action as CombatActionMovement);
  }

  for(var effect in action.effects) {
    SessionMessageBusClient.instance?.publish(effect);
  }
}

void _executeMovementAction(CombatActionMovement action) {
  SessionMessageBusClient.instance?.publish(
    SessionEntityPositionStatusMessage(
      broadcastIncludesSelf: true,
      mapId: action.mapId,
      entityId: action.entityId,
      x: action.path.segments.last.end.dx,
      y: action.path.segments.last.end.dy,
    )
  );
}

void _executeAttackAction(CombatActionAttack action) {
  var messageBus = SessionMessageBusClient.instance;
  if(messageBus == null) {
    throw(
      SessionMessageBusClientException(
        "Aucune instance du bus de message n'a été trouvée, impossible de planifier l'action",
      )
    );
  }

  if(action.context.cumulativeAttackMalus != 0) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: action.entityId,
        property: EntityMessageProperty.addCumulativeAttackMalus,
        value: action.context.cumulativeAttackMalus,
      )
    );
  }

  if((action.context.cumulativeDefenseMalus ?? 0) != 0) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: action.context.targetId,
        property: EntityMessageProperty.addCumulativeDefenseMalus,
        value: action.context.cumulativeDefenseMalus!,
      )
    );
  }
}