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
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/shield.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/assign_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/select_actions.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/set_combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';

class ActionInitializerAttackSimple extends ActionInitializerAttack {
  ActionInitializerAttackSimple({
    required super.weapon,
    required super.target,
    required this.icon,
  });

  @override
  String get name => CombatActionAttackBaseType.simple.title;

  @override
  final IconData icon;

  @override
  Future<void> plan(BuildContext context, SessionEncounterEntityAction action) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      // TODO: display a message
      return;
    }

    var controllingClient = messageBus.clientControlling(action.entity.id);

    var actionResponse = await messageBus.publishAndWaitForResponse(
      SessionEncounterTurnSelectActions(
        destination: controllingClient,
        description: "Sélectionner l'action de défense",
        entityId: target.id,
        allowEmptySelection: true,
        usage: CombatActionType.defense,
      )
    );
    if(!context.mounted) return;

    var (cancelAction, cancelReason) = mustCancelAction(actionResponse);
    if(cancelAction) {
      return;
    }

    var actions = (actionResponse.data as List<SessionEncounterEntityAction>?);
    SessionEncounterEntityAction? defenseAction;
    CombatActionDefense? defenseCombatAction;

    if(actions != null && actions.isNotEmpty) {
      defenseAction = actions.first;

      var options = <SimpleDialogOption>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              CombatActionDefenseDodge(
                entityId: target.id,
                rank: defenseAction!.rank,
              )
            );
          },
          child: Text(
            CombatActionDefenseType.dodge.title,
          ),
        )
      ];

      for(var eq in target.equiped().whereType<Shield>()) {
        options.add(
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(
                CombatActionDefenseParryShield(
                  entityId: target.id,
                  rank: defenseAction!.rank,
                  shield: eq,
                )
              );
            },
            child: Text(
              CombatActionDefenseType.parryShield.title,
            ),
          )
        );
      }

      List<EquipableItemSlot> usableHands;
      if(defenseAction.weakHand) {
        usableHands = [EquipableItemSlot.weakHand];
      }
      else {
        usableHands = [EquipableItemSlot.dominantHand, EquipableItemSlot.weakHand];
      }

      for(var hand in usableHands) {
        for(var dp in target.damageProviderForHand(hand).whereType<Weapon>()) {

          options.add(
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(
                  CombatActionDefenseParryWeapon(
                    entityId: target.id,
                    rank: defenseAction!.rank,
                    weapon: dp,
                  )
                );
              },
              child: Text(
                '${CombatActionDefenseType.parryWeapon.title} (${dp.name})',
              ),
            )
          );
        }
      }

      defenseCombatAction = await showDialog<CombatActionDefense>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: const Text('Type de défense'),
          children: options,
        )
      );
      if(!context.mounted) return;

      if(defenseCombatAction != null) {
        var assignResponse = await messageBus.publishAndWaitForResponse(
          SessionEncounterTurnAssignCombatActionMessage(
            destination: SessionMessage.masterIdentifier,
            actionUuid: defenseAction.uuid,
            combatAction: defenseCombatAction,
          )
        );

        if (assignResponse.status != SessionMessageResponseStatus.accepted) {
          // TODO: display a message
          return;
        }
      }
    }

    // TODO

    if(defenseAction != null && defenseCombatAction != null) {
      var setResponse = await messageBus.publishAndWaitForResponse(
        SessionEncounterTurnSetCombatActionMessage(
          destination: SessionMessage.masterIdentifier,
          actionUuid: defenseAction.uuid,
          combatAction: defenseCombatAction,
        )
      );

      if(setResponse.status != SessionMessageResponseStatus.accepted) {
        // TODO: display a message
        return;
      }
    }
  }
}