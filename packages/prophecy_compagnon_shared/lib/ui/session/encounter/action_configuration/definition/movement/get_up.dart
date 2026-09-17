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
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/ability.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/implementations/effect.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effects/combat_status.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/action_configuration.dart';
import 'package:prophecy_compagnon_shared/ui/session/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/action/dice_throw_request.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/set_combat_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message_response.dart';

class ActionConfigurationMovementGetUp extends ActionConfiguration {
  ActionConfigurationMovementGetUp();

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

    var controllingClient = messageBus.clientControlling(action.entity.id);
    // TODO: use the movement malus from the entity
    var difficulty = 0;
    var request = DiceThrowRequest(
      type: DiceThrowRequestType.simple,
      context: DiceThrowRequestContext.none,
      difficulty: difficulty,
      base: DiceThrowEntityBaseAbility(
        attribute: Attribute.physique,
        ability: Ability.coordination,
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

    var evaluation = evaluateDiceThrow(bundle);
    if(evaluation.resultType == DiceThrowResultType.success) {
      var setResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnSetCombatActionMessage(
          destination: SessionMessage.masterIdentifier,
          actionUuid: action.uuid,
          combatAction: CombatActionEffect(
            entityId: action.entity.id,
            rank: action.rank,
            effects: [
              EffectClearCombatStatus(
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
    }
  }
}