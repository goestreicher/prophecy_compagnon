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

import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/implementations/movement.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/status/entity_effect.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/status/entity_position_status.dart';

void executeRankAction(CombatAction action) {
  switch(action.type) {
    case CombatActionType.effect:
      // Nothing to do here, effects are managed below
      break;
    case CombatActionType.movement:
      _executeMovementAction(action as CombatActionMovement);
  }

  for(var effect in action.effects) {
    SessionMessageBusClient.instance?.publish(
      SessionEntitySetEffectMessage(
        broadcastIncludesSelf: true,
        entityId: action.entityId,
        effect: effect,
      )
    );
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