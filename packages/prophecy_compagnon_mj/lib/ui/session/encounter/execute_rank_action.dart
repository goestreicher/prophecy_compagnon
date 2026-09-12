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