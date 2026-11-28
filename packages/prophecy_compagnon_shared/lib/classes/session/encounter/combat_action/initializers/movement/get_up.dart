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
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/ability.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/armor.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/shield.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/dice_throw_history_entry.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/effect.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/action_initializer.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/action/dice_throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/set_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart';

class ActionInitializerMovementGetUp extends ActionInitializer {
  ActionInitializerMovementGetUp();

  @override
  String get name => CombatActionMovementType.sprint.title;

  @override
  IconData get icon => CombatActionMovementType.sprint.icon;

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
    var difficulty = 0;
    for(var pp in action.entity.protectionProviders) {
      if(pp is Armor) {
        difficulty += (pp.model as ArmorModel).protection;
      }
      else if(pp is Shield) {
        difficulty += (pp.model as ShieldModel).protection;
      }
    }
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
      throw(
        ActionInitializerException(
          title: "Demande de jet de dé non acceptée",
          message:
            "La demande de jet de dé n'a pas été acceptée (statut "
            "${diceThrowResponse.status}), impossible de planifier l'action"
        )
      );
    }

    if(diceThrowResponse.data is! EntityThrowBundle) {
      throw(
        ActionInitializerException(
          title: "Réponse au jet invalide",
          message:
            "La réponse au jet n'est pas au format attendu "
            "(${diceThrowResponse.runtimeType} au lieu de EntityThrowBundle, "
            "impossible de planifier l'action"
        )
      );
    }

    var bundle = diceThrowResponse as EntityThrowBundle;

    var evaluation = evaluateDiceThrow(bundle);

    GameSession.instance!.diceThrowHistory.add(
      DiceThrowHistoryEntry(
        actor: bundle.entity,
        request: bundle.request,
        evaluation: evaluation,
      )
    );

    if(evaluation.resultType == DiceThrowResultType.success) {
      var candidates = action.entity.effects
          .where(
              (EntityEffect e) =>
                  e is EntityEffectCombatStatus
                  && e.status == EntityCombatStatusFlag.onGround
          );

      if(candidates.isEmpty) {
        throw(
          ActionInitializerException(
            title: "Aucun effet 'Au sol'",
            message:
              "Ce personnage n'a pas d'effet \"Au sol\" actif, "
              "impossible de planifier l'action"
          )
        );
      }

      var setResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnSetCombatActionMessage(
          destination: SessionMessage.masterIdentifier,
          actionUuid: action.uuid,
          combatAction: CombatActionEffect(
            entityId: action.entity.id,
            rank: action.rank,
            effects: [
              SessionEntityUnapplyEffectMessage(
                entityId: action.entity.id,
                effectId: candidates.first.id,
              ),
            ]
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
}