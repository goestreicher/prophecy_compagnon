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

import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/character/character_disadvantage.dart';
import 'package:prophecy_compagnon_shared/classes/character/disadvantages.dart';
import 'package:prophecy_compagnon_shared/classes/character/tendencies.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_matchers/request_context.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_enums.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/ability_change.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/attribute_change.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/damage.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/damage_armor.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/damage_malus_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/dice_throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/disadvantage.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/gain_experience.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/gain_luck.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/gain_proficiency.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/initiative_extra_dice.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/injury.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/tendency_circles.dart';
import 'package:prophecy_compagnon_shared/classes/entity/injury.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/armor.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/dice_throw_history_entry.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/action_initializer.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/context.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/utils.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/assign_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/select_actions.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/set_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';
import 'package:prophecy_compagnon_shared/ui/dice_roll_input_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';

part 'attack.internal.cc.dart';

abstract class ActionInitializerAttack extends ActionInitializer {
  ActionInitializerAttack({
    required EntityBase attacker,
    required Weapon weapon,
    required EntityBase target,
  })
    : attackContext = ActionInitializerAttackContext(
        attacker: attacker,
        weapon: weapon,
        target: target,
      );

  final ActionInitializerAttackContext attackContext;

  int get attackDifficulty;
  int get dodgeDifficulty;
  int get parryDifficulty;
  int get damageModifier => 0;
  int get armorModifier => 0;

  @override
  Future<void> plan(BuildContext context, SessionEncounterEntityAction action) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      throw(
        SessionMessageBusClientException(
          "Aucune instance du bus de message n'a été trouvée, impossible de planifier l'action",
        )
      );
    }

    await selectTargetDefense(
      context: context,
      rank: action.rank,
    );
    if(!context.mounted) return;

    createAttackRequest();
    var entities = <EntityBase>[];

    if(attackContext.defenseCombatAction != null) {
      createDefenseRequest();
      entities.addAll([attackContext.attacker, attackContext.target]);
    }
    else {
      entities.add(attackContext.attacker);
    }

    var bundles = await showDialog<List<EntityThrowBundle>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => EntityDiceThrowDialog(
        entities: entities,
        request: attackContext.attackRequest,
        opposingRequest: attackContext.defenseRequest,
        canChangeDifficulty: false,
      ),
    );
    if(bundles == null || bundles.isEmpty || !context.mounted) {
      if(attackContext.defenseAction != null) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: attackContext.defenseAction!.uuid,
          )
        );
      }
      return;
    }

    DiceThrowEvaluation attackEvaluation;
    DiceThrowEvaluation? defenseEvaluation;
    if(attackContext.defenseCombatAction != null) {
      attackEvaluation = evaluateDiceThrow(
        bundles[0],
        opposing: bundles[1]
      );
      defenseEvaluation = evaluateDiceThrow(
        bundles[1],
        opposing: bundles[0],
        dispatchPropertyUpdates: false
      );
    }
    else {
      attackEvaluation = evaluateDiceThrow(bundles[0]);
    }

    GameSession.instance!.diceThrowHistory.add(
      DiceThrowHistoryEntry(
        actor: bundles[0].entity,
        opposing: attackContext.defenseCombatAction != null
          ? bundles[1].entity
          : null,
        request: bundles[0].request,
        opposingRequest: attackContext.defenseCombatAction != null
          ? bundles[1].request
          : null,
        evaluation: attackEvaluation,
      )
    );

    if(
        (
            attackEvaluation.resultType == DiceThrowResultType.success
            || attackEvaluation.criticalType == DiceThrowResultType.criticalSuccess
        )
        && defenseEvaluation?.criticalType != DiceThrowResultType.criticalSuccess
    ) {
      attackContext.damage = attackContext.weapon.damage(attackContext.attacker) + damageModifier;
      for(var i = 0; i < attackEvaluation.nr; ++i) {
        attackContext.damage += Random().nextInt(10) + 1;
      }

      if(attackEvaluation.criticalType == DiceThrowResultType.criticalSuccess) {
        var criticalTableResult = await showDialog<int>(
          context: context,
          builder: (BuildContext context) => DiceRollInputDialog(
            title: "Dé de critique",
            count: 1,
          )
        );
        if(!context.mounted) return;

        criticalTableResult ??= Random().nextInt(10) + 1;
        Future<void> Function(BuildContext, int, ActionInitializerAttackContext) handler;

        if(bundles[0].result.usedTendencies) {
          switch(bundles[0].result.keptTendency!) {
            case Tendency.dragon:
              criticalTableResult += (attackContext.attacker as HumanCharacter).tendencies.dragon.value;
              handler = _manageDragonCritical;
            case Tendency.fatality:
              criticalTableResult += (attackContext.attacker as HumanCharacter).tendencies.fatality.value;
              handler = _manageFatalityCritical;
            case Tendency.human:
              criticalTableResult += (attackContext.attacker as HumanCharacter).tendencies.human.value;
              handler = _manageHumanCritical;
          }

        }
        else {
          handler = _manageGeneralCritical;
        }

        await handler(context, criticalTableResult, attackContext);
        if(!context.mounted) return;
      }

      if(!attackContext.ignoreArmor) {
        var protection = 0;
        for(var pp in attackContext.target.protectionProviders) {
          if((attackContext.defenseCombatAction?.useProtectionProvider(pp) ?? true)) {
            // TODO: manage weapons or attack dividing or ignoring armors
            protection += pp.protection();
          }
        }

        if(protection > 0) {
          protection -= armorModifier;
          if(protection < 0) protection = 0;
          attackContext.damage -= protection;
        }
      }

      if(attackContext.damage > 0) {
        attackContext.attackEffects.add(
          SessionEntityAddEffectMessage(
            broadcastIncludesSelf: true,
            entityId: attackContext.attacker.id,
            effect: EntityEffectDamage(
              name: 'Dégâts',
              trigger: EntityEffectTrigger.once,
              amount: attackContext.damage,
              inflictedInjuryProperties: attackContext.inflictedInjuryProperties,
              statusMessageTitle: attackContext.damageEffectMessageTitle,
              statusMessageText:
                "${attackContext.damageEffectMessageText != null ? '${attackContext.damageEffectMessageText}\n' : ''}"
                "${attackContext.attacker.name} inflige ${attackContext.damage} "
                "dégâts à ${attackContext.target.name}",
            ),
          )
        );
      }
    }
    else if(
        defenseEvaluation?.resultType == DiceThrowResultType.success
        && (defenseEvaluation?.nr ?? 0) >= 2
    ) {
      // TODO: riposte with 2NR
    }

    // TODO: allow a review of the attack context by the DM, so that they can change damages / effects, etc.

    if(attackContext.defenseAction != null && attackContext.defenseCombatAction != null) {
      var setResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnSetCombatActionMessage(
          destination: SessionMessage.masterIdentifier,
          actionUuid: attackContext.defenseAction!.uuid,
          combatAction: attackContext.defenseCombatAction!,
        )
      );

      if(setResponse.status != SessionMessageResponseStatus.accepted) {
        throw(
          ActionInitializerException(
            title: "Affectation de l'action de défense non acceptée",
            message:
              "La demande d'affectation de l'action n'a pas été acceptée (statut "
              "${setResponse.status}), impossible de planifier l'action"
          )
        );
      }
    }

    attackContext.cumulativeDefenseMalus =
      attackContext.defenseCombatAction != null
        ? -5
        : 0;

    var setResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSetCombatActionMessage(
        destination: SessionMessage.masterIdentifier,
        actionUuid: action.uuid,
        combatAction: CombatActionAttack(
          entityId: attackContext.attacker.id,
          rank: action.rank,
          effects: attackContext.attackEffects,
          context: attackContext.toCombatActionAttackContext(),
        ),
      )
    );

    if(setResponse.status != SessionMessageResponseStatus.accepted) {
      if(attackContext.defenseAction != null) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: attackContext.defenseAction!.uuid,
          )
        );
      }

      throw(
        ActionInitializerException(
          title: "Affectation de l'action d'attaque non acceptée",
          message:
            "La demande d'affectation de l'action n'a pas été acceptée (statut "
            "${setResponse.status}), impossible de planifier l'action"
        )
      );
    }
  }

  @protected
  Future<void> selectTargetDefense({
    required BuildContext context,
    required int rank,
  }) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      throw(SessionMessageBusClientException("No SessionMessageBusClient instance"));
    }

    var controllingClient = messageBus.clientControlling(attackContext.target.id);

    var defenseActionResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSelectActions(
        destination: controllingClient,
        description: "Sélectionner l'action de défense",
        entityId: attackContext.target.id,
        allowEmptySelection: true,
        usage: CombatActionType.defense,
      )
    );
    if(!context.mounted) return;

    var (cancelAction, cancelReason) = mustCancelAction(defenseActionResponse);
    if(cancelAction) {
      return;
    }

    var defenseActions = (defenseActionResponse.data as List<SessionEncounterEntityAction>?);

    if(defenseActions != null && defenseActions.isNotEmpty) {
      attackContext.defenseAction = defenseActions.first;
      var availableDefenseActions = getAvailableDefenseCombatActions(
        target: attackContext.target,
        rank: rank,
        weakHand: attackContext.defenseAction!.weakHand,
      );

      attackContext.defenseCombatAction = await showDialog<CombatActionDefense>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: const Text('Type de défense'),
          children: availableDefenseActions
            .map(
              (CombatActionDefense a) => SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(a);
                },
                child: Text(
                  a.defenseType.title,
                ),
              )
            )
            .toList(),
        ),
      );
      if(!context.mounted) return;

      if(attackContext.defenseCombatAction != null) {
        var assignResponse = await messageBus.publishAndWaitForResponse(
          SessionEncounterTurnAssignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: attackContext.defenseAction!.uuid,
            combatAction: attackContext.defenseCombatAction!,
          )
        );
        if(!context.mounted) return;

        if (assignResponse.status != SessionMessageResponseStatus.accepted) {
          throw(
            ActionInitializerException(
              title: "Demande d'assignation d'action de défense non acceptée",
              message:
                "La demande d'assignation pour l'action de rang "
                "${attackContext.defenseAction!.rank} n'a pas été acceptée "
                "(statut ${assignResponse.status}), impossible de planifier l'action"
            )
          );
        }
      }
    }
  }

  @protected
  void createAttackRequest() {
    attackContext.attackRequest = DiceThrowRequest(
      type: attackContext.defenseCombatAction == null
        ? DiceThrowRequestType.simple
        : DiceThrowRequestType.oppositionNR,
      context: DiceThrowRequestContext.attack,
      difficulty: attackDifficulty,
      base: DiceThrowEntityBaseSkill(
        attribute: Attribute.physique,
        specialization: (attackContext.weapon.model as WeaponModel).skill,
        ability: (attackContext.weapon.model as WeaponModel).ability,
      )
    );
  }

  @protected
  void createDefenseRequest() {
    attackContext.defenseRequest = DiceThrowRequest(
      type: DiceThrowRequestType.oppositionNR,
      context: DiceThrowRequestContext.defense,
      difficulty: attackContext.defenseCombatAction!.defenseType == CombatActionDefenseType.dodge
        ? dodgeDifficulty
        : parryDifficulty,
      base: attackContext.defenseCombatAction!.diceThrowBase(),
    );
  }
}