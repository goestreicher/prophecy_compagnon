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
import 'package:prophecy_compagnon_shared/classes/entity/effects/damage.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/damage_malus_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/dice_throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/gain_luck.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/gain_proficiency.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/initiative_extra_dice.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effects/injury.dart';
import 'package:prophecy_compagnon_shared/classes/entity/injury.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/dice_throw_history_entry.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/action_initializer.dart';
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

abstract class ActionInitializerAttack extends ActionInitializer {
  ActionInitializerAttack({
    required this.weapon,
    required this.target,
  });

  final Weapon weapon;
  final EntityBase target;

  int get attackDifficulty;
  int get dodgeDifficulty;
  int get parryDifficulty;
  int get damageModifier => 0;
  int get armorModifier => 0;

  @protected
    SessionEncounterEntityAction? defenseAction;
  @protected
    CombatActionDefense? defenseCombatAction;
  @protected
    late DiceThrowRequest attackRequest;
  @protected
    DiceThrowRequest? defenseRequest;
  @protected
    int damage = 0;
  @protected
    final List<SessionMessage> attackEffects = <SessionMessage>[];
  @protected
    bool ignoreArmor = false;

  @override
  Future<void> plan(BuildContext context, SessionEncounterEntityAction action) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      // TODO: display a message
      return;
    }

    await selectTargetDefense(
      context: context,
      rank: action.rank,
    );
    if(!context.mounted) return;

    createAttackRequest();
    var entities = <EntityBase>[];

    if(defenseCombatAction != null) {
      createDefenseRequest();
      entities.addAll([action.entity, target]);
    }
    else {
      entities.add(action.entity);
    }

    var bundles = await showDialog<List<EntityThrowBundle>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => EntityDiceThrowDialog(
        entities: entities,
        request: attackRequest,
        opposingRequest: defenseRequest,
        canChangeDifficulty: false,
      ),
    );
    if(bundles == null || bundles.isEmpty || !context.mounted) {
      if(defenseAction != null) {
        messageBus.publish(
          SessionEncounterTurnUnassignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: defenseAction!.uuid,
          )
        );
      }
      return;
    }

    DiceThrowEvaluation attackEvaluation;
    DiceThrowEvaluation? defenseEvaluation;
    if(defenseCombatAction != null) {
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
        opposing: defenseCombatAction != null
          ? bundles[1].entity
          : null,
        request: bundles[0].request,
        opposingRequest: defenseCombatAction != null
          ? bundles[0].request
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
      damage = weapon.damage(action.entity) + damageModifier;
      for(var i = 0; i < attackEvaluation.nr; ++i) {
        damage += Random().nextInt(10) + 1;
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
        Future<void> Function(BuildContext, int, String) handler;

        if(bundles[0].result.usedTendencies) {
          switch(bundles[0].result.keptTendency!) {
            case Tendency.dragon:
              criticalTableResult += (action.entity as HumanCharacter).tendencies.dragon.value;
              handler = _manageDragonCritical;
            case Tendency.fatality:
              criticalTableResult += (action.entity as HumanCharacter).tendencies.fatality.value;
              handler = _manageFatalityCritical;
            case Tendency.human:
              criticalTableResult += (action.entity as HumanCharacter).tendencies.human.value;
              handler = _manageHumanCritical;
          }

        }
        else {
          handler = _manageGeneralCritical;
        }

        await handler(context, criticalTableResult, action.entity.id);
        if(!context.mounted) return;
      }

      if(!ignoreArmor) {
        for (var pp in target.protectionProviders) {
          var protection = pp.protection() - armorModifier;
          // TODO: manage weapons or attack dividing or ignoring armors
          // TODO: manage shields when used to parry an attack (in which case their protection don't apply)
          if (protection > 0) {
            damage -= protection;
          }
        }
      }

      if(damage > 0) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            broadcastIncludesSelf: true,
            entityId: action.entity.id,
            effect: EntityEffectDamage(
              name: 'Dégâts',
              trigger: EntityEffectTrigger.once,
              amount: damage,
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

    var setResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSetCombatActionMessage(
        destination: SessionMessage.masterIdentifier,
        actionUuid: action.uuid,
        combatAction: CombatActionAttack(
          entityId: action.entity.id,
          rank: action.rank,
          effects: attackEffects,
        ),
      )
    );

    if(setResponse.status != SessionMessageResponseStatus.accepted) {
      // TODO: display a message
      // unassign the defense action?
      return;
    }

    if(defenseAction != null && defenseCombatAction != null) {
      setResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnSetCombatActionMessage(
          destination: SessionMessage.masterIdentifier,
          actionUuid: defenseAction!.uuid,
          combatAction: defenseCombatAction!,
        )
      );

      if(setResponse.status != SessionMessageResponseStatus.accepted) {
        // TODO: display a message
        return;
      }
    }

    // TODO
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

    var controllingClient = messageBus.clientControlling(target.id);

    var defenseActionResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSelectActions(
        destination: controllingClient,
        description: "Sélectionner l'action de défense",
        entityId: target.id,
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
      defenseAction = defenseActions.first;
      var availableDefenseActions = getAvailableDefenseCombatActions(
        target: target,
        rank: rank,
        weakHand: defenseAction!.weakHand,
      );

      defenseCombatAction = await showDialog<CombatActionDefense>(
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

      if(defenseCombatAction != null) {
        var assignResponse = await messageBus.publishAndWaitForResponse(
          SessionEncounterTurnAssignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: defenseAction!.uuid,
            combatAction: defenseCombatAction!,
          )
        );
        if(!context.mounted) return;

        if (assignResponse.status != SessionMessageResponseStatus.accepted) {
          // TODO: display a message
          return;
        }
      }
    }
  }

  @protected
  void createAttackRequest() {
    attackRequest = DiceThrowRequest(
      type: defenseCombatAction == null
        ? DiceThrowRequestType.simple
        : DiceThrowRequestType.oppositionNR,
      context: DiceThrowRequestContext.attack,
      difficulty: attackDifficulty,
      base: DiceThrowEntityBaseSkill(
        attribute: Attribute.physique,
        specialization: (weapon.model as WeaponModel).skill,
        ability: (weapon.model as WeaponModel).ability,
      )
    );
  }

  @protected
  void createDefenseRequest() {
    defenseRequest = DiceThrowRequest(
      type: DiceThrowRequestType.oppositionNR,
      context: DiceThrowRequestContext.defense,
      difficulty: defenseCombatAction!.defenseType == CombatActionDefenseType.dodge
        ? dodgeDifficulty
        : parryDifficulty,
      base: defenseCombatAction!.diceThrowBase(),
    );
  }

  Future<void> _manageGeneralCritical(BuildContext context, int result, String attackerId) async {
    if(result == 1) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Choc',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.action,
              count: defenseCombatAction == null ? 1 : 2,
            ),
            removeOnUnapply: true,
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 2) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectDamageMalusModifier(
            name: 'Coup critique - Douleur',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.combat,
              count: 1,
            ),
            removeOnUnapply: true,
            value: 1,
          ),
        )
      );
    }
    else if(result == 3) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Sonné',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.turn,
              count: 2,
            ),
            removeOnUnapply: true,
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 4) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectInjury(
            name: 'Coup critique - Hémorragie mineure',
            trigger: EntityEffectTrigger.tickerEvent,
            triggerTickerEvent: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.turn,
            ),
            removeOnUnapply: true,
            injury: Injury.light,
            count: 1,
          ),
        )
      );
    }
    else if(result == 5) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectAbilityChange(
            name: 'Coup critique - Cicatrice',
            trigger: EntityEffectTrigger.once,
            ability: Ability.presence,
            value: -1,
          ),
        )
      );
    }
    else if(result == 6) {
      // TODO
    }
    else if(result == 7) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: "Coup critique - Main d'arme",
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.hour,
              count: 24,
            ),
            removeOnUnapply: true,
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 8) {
      // TODO
    }
    else if(result == 9) {
      ignoreArmor = true;
      damage += 20;
    }
    else if(result == 10) {
      // TODO
    }
  }

  Future<void> _manageDragonCritical(BuildContext context, int result, String attackerId) async {
    if(result == 1) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Choc',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.action,
              count: defenseCombatAction == null ? 1 : 2,
            ),
            removeOnUnapply: true,
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 2) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Sonné',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.turn,
              count: 2,
            ),
            removeOnUnapply: true,
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 3) {
      attackEffects.addAll([
        SessionEntityAddEffectMessage(
          entityId: attackerId,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Maîtrise',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.turn,
              count: 1,
            ),
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: -5,
            singleUse: true,
            matcher: ThrowRequestContextDiceThrowMatcher(
              context: DiceThrowRequestContext.defense,
            ),
          ),
        ),
        SessionEntityAddEffectMessage(
          entityId: attackerId,
          effect: EntityEffectGainProficiency(
            name: 'Coup critique - Maîtrise',
            trigger: EntityEffectTrigger.once,
            amount: 2,
          )
        ),
      ]);
    }
    else if(result == 4) {
      // TODO
    }
    else if(result == 5) {
      // TODO
    }
    else if(result == 6) {
      // TODO
    }
    else if(result == 7) {
      int? choice = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SimpleDialog(
          title: Text('Coup critique - Conviction'),
          children: [
            Text("L'attaquant peut regagner tous ses points de Chance ou de Maîtrise, au choix :"),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(1);
              },
              child: Text('Regagner tous les points de Maîtrise'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(2);
              },
              child: Text('Regagner tous les points de Chance'),
            ),
          ],
        )
      );
      if(!context.mounted) return;

      EntityEffect effect;
      if(choice! == 1) {
        effect = EntityEffectGainProficiency(
          name: 'Coup critique - Conviction',
          trigger: EntityEffectTrigger.once,
          amount: 10,
        );
      }
      else {
        effect = EntityEffectGainLuck(
          name: 'Coup critique - Conviction',
          trigger: EntityEffectTrigger.once,
          amount: 10,
        );
      }

      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackerId,
          effect: effect,
        )
      );
    }
    else if(result == 8) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackerId,
          effect: EntityEffectInitiativeExtraDice(
            name: 'Coup critique - Tactique',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.turn,
              count: 2,
            ),
            removeOnUnapply: true,
            count: 2
          )
        )
      );
    }
    else if(result == 9) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectInjury(
            name: 'Coup critique - Hémorragie',
            trigger: EntityEffectTrigger.permanent,
            removeOnUnapply: true,
            injury: Injury.scratch,
            count: 1,
          )
        )
      );
    }
    else if(result == 10) {
      // TODO
    }
    else if(result == 11) {
      // TODO
    }
    else if(result == 12) {
      bool hasOneGrave = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.grave);
        hasOneGrave = capacity < 2;
      }
      on ArgumentError {
        hasOneGrave = true;
      }

      if(hasOneGrave) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Défaut critique',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 10;
        ignoreArmor = true;
      }
    }
    else if(result == 13) {
      bool hasOneFatal = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.fatal);
        hasOneFatal = capacity < 2;
      }
      on ArgumentError {
        hasOneFatal = true;
      }

      if(hasOneFatal) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Coup mortel',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 20;
        ignoreArmor = true;
      }
    }
    else if(result == 14) {
      bool hasOneDeath = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.death);
        hasOneDeath = capacity < 2;
      }
      on ArgumentError {
        hasOneDeath = true;
      }

      if(hasOneDeath) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Coup magistral',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 20;
        ignoreArmor = true;
      }
    }
    else if(result == 15) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectInjury(
            name: 'Coup critique - Guidé par Kroryn',
            trigger: EntityEffectTrigger.once,
            injury: Injury.death,
          )
        )
      );
    }
  }

  Future<void> _manageFatalityCritical(BuildContext context, int result, String attackerId) async {
    if(result == 1) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Choc',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.action,
              count: defenseCombatAction == null ? 1 : 2,
            ),
            removeOnUnapply: true,
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 2) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectDamageMalusModifier(
            name: 'Coup critique - Douleur',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.combat,
              count: 1,
            ),
            removeOnUnapply: true,
            value: 1,
          ),
        )
      );
    }
    else if(result == 3) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectAbilityChange(
            name: 'Coup critique - Cicatrice',
            trigger: EntityEffectTrigger.once,
            ability: Ability.presence,
            value: -1,
          ),
        )
      );
    }
    else if(result == 4) {
      // TODO
    }
    else if(result == 5) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Doute',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.combat,
              count: 1,
            ),
            removeOnUnapply: true,
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 2,
          ),
        )
      );
    }
    else if(result == 6) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectInjury(
            name: 'Coup critique - Hémorragie',
            trigger: EntityEffectTrigger.permanent,
            removeOnUnapply: true,
            injury: Injury.scratch,
            count: 1,
          )
        )
      );
    }
    else if(result == 7) {
      // TODO
    }
    else if(result == 8) {
      // TODO
    }
    else if(result == 9) {
      ignoreArmor = true;
    }
    else if(result == 10) {
      // TODO
    }
    else if(result == 11) {
      bool hasOneGrave = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.grave);
        hasOneGrave = capacity < 2;
      }
      on ArgumentError {
        hasOneGrave = true;
      }

      if(hasOneGrave) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Défaut critique',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 10;
        ignoreArmor = true;
      }
    }
    else if(result == 12) {
      bool hasOneFatal = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.fatal);
        hasOneFatal = capacity < 2;
      }
      on ArgumentError {
        hasOneFatal = true;
      }

      if(hasOneFatal) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Coup mortel',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 20;
        ignoreArmor = true;
      }
    }
    else if(result == 13) {
      bool hasOneDeath = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.death);
        hasOneDeath = capacity < 2;
      }
      on ArgumentError {
        hasOneDeath = true;
      }

      if(hasOneDeath) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Coup magistral',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 20;
        ignoreArmor = true;
      }
    }
    else if(result == 14) {
      // TODO
    }
    else if(result == 15) {
      // TODO
    }
  }

  Future<void> _manageHumanCritical(BuildContext context, int result, String attackerId) async {
    if(result == 1) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Choc',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.action,
              count: defenseCombatAction == null ? 1 : 2,
            ),
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 2) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: 'Coup critique - Sonné',
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.turn,
              count: 2,
            ),
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 3) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackerId,
          effect: EntityEffectInitiativeExtraDice(
              name: 'Coup critique - Surpris',
              trigger: EntityEffectTrigger.permanent,
              duration: TickerEvent(
                type: TickerEventType.end,
                unit: TickerEventUnit.turn,
                count: 2,
              ),
              removeOnUnapply: true,
              count: 1
          )
        )
      );
    }
    else if(result == 4) {
      // TODO
    }
    else if(result == 5) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackerId,
          effect: EntityEffectGainProficiency(
            name: 'Coup critique - Technique',
            trigger: EntityEffectTrigger.once,
            amount: 10,
          )
        )
      );
    }
    else if(result == 6) {
      attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: target.id,
          effect: EntityEffectGlobalDiceThrowModifier(
            name: "Coup critique - Main d'arme",
            trigger: EntityEffectTrigger.permanent,
            duration: TickerEvent(
              type: TickerEventType.end,
              unit: TickerEventUnit.hour,
              count: 24,
            ),
            removeOnUnapply: true,
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.attackEffect,
            modifier: 5,
          ),
        )
      );
    }
    else if(result == 7) {
      ignoreArmor = true;
    }
    else if(result == 8) {
      ignoreArmor = true;
      attackEffects.addAll([
        SessionEntityAddEffectMessage(
          entityId: attackerId,
          effect: EntityEffectGainLuck(
            name: 'Coup critique - Coup de chance',
            trigger: EntityEffectTrigger.once,
            amount: 10,
          )
        )
      ]);
    }
    else if(result == 9) {
      // TODO
    }
    else if(result == 10) {
      bool hasOneGrave = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.grave);
        hasOneGrave = capacity < 2;
      }
      on ArgumentError {
        hasOneGrave = true;
      }

      if(hasOneGrave) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Défaut critique',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 10;
        ignoreArmor = true;
      }
    }
    else if(result == 11) {
      bool hasOneFatal = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.fatal);
        hasOneFatal = capacity < 2;
      }
      on ArgumentError {
        hasOneFatal = true;
      }

      if(hasOneFatal) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Coup mortel',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 20;
        ignoreArmor = true;
      }
    }
    else if(result == 12) {
      bool hasOneDeath = false;
      try {
        var capacity = target.injuries.manager.capacity(Injury.death);
        hasOneDeath = capacity < 2;
      }
      on ArgumentError {
        hasOneDeath = true;
      }

      if(hasOneDeath) {
        attackEffects.add(
          SessionEntityAddEffectMessage(
            entityId: target.id,
            effect: EntityEffectInjury(
              name: 'Coup critique - Coup magistral',
              trigger: EntityEffectTrigger.once,
              injury: Injury.death,
            )
          )
        );
      }
      else {
        damage += 20;
        ignoreArmor = true;
      }
    }
    else if(result == 13) {
      // TODO
    }
    else if(result == 14) {
      // TODO
    }
    else if(result == 15) {
      // TODO
    }
  }
}