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
import 'package:prophecy_compagnon_shared/classes/combat.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack_contact.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack_distance.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack_melee.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack_ranged.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/action_initializer.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/shared/simple.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/map/select_target.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/responses/action/select_target_result.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';

class ActionInitializerWeapon extends ActionInitializer {
  ActionInitializerWeapon({ required this.weapon });

  final Weapon weapon;

  @override
  String get name => '${CombatActionType.attack.title} (${weapon.name})';

  @override
  IconData get icon => CombatActionType.attack.icon;

  @override
  Future<void> plan(BuildContext context, SessionEncounterEntityAction action) async {
    await guardPlan(context, action, _doPlan);
  }

  Future<void> _doPlan(BuildContext context, SessionEncounterEntityAction action) async {
    var messageBus = SessionMessageBusClient.instance;
    if(messageBus == null) {
      // TODO: display a message
      return;
    }

    var controllingClient = messageBus.clientControlling(action.entity.id);

    var distance = weapon.distanceMax(action.entity);
    if(weapon.range != WeaponRange.ranged) {
      distance += action.entity.reach;
    }

    var targetResponse = await messageBus.publishAndWaitForResponse(
      SessionMapSelectTarget(
        destination: controllingClient,
        entityId: action.entity.id,
        distance: distance,
        waitResponseTimeout: 60,
      )
    );
    if(!context.mounted) return;

    var (cancelAction, cancelReason) = mustCancelAction(targetResponse);

    if(cancelAction) {
      messageBus.publish(
        SessionMapCancelSelectTarget(
          destination: SessionMessage.masterIdentifier,
          entityId: action.entity.id,
          cancelReason: cancelReason,
        )
      );

      return;
    }

    var r = (targetResponse.data as SessionSelectTargetResult?);
    if(r == null || GameSession.instance!.entity(r.entityId) == null) {
      // TODO: display a nice message?
      return;
    }

    var target = GameSession.instance?.entity(r.entityId);
    if(target == null) {
      // TODO: display a message
      return;
    }

    var options = <SimpleDialogOption>[];
    // TODO: list all possible attacks, depending on the weapon type
    switch(weapon.range) {
      case WeaponRange.contact:
        // TODO: manage grappling here
        for(var t in CombatActionAttackContactType.values) {
          options.add(
            SimpleDialogOption(
              onPressed: () {
                ActionInitializerAttack initializer;
                switch(t) {
                  case CombatActionAttackContactType.simple:
                    initializer = ActionInitializerAttackSimple(
                      weapon: weapon,
                      target: target,
                      icon: t.icon,
                    );
                }

                Navigator.of(context, rootNavigator: true).pop(initializer);
              },
              child: Text(
                t.title,
              )
            )
          );
        }
      case WeaponRange.melee:
        for(var t in CombatActionAttackMeleeType.values) {
          options.add(
            SimpleDialogOption(
              onPressed: () {
                ActionInitializerAttack initializer;
                switch(t) {
                  case CombatActionAttackMeleeType.simple:
                    initializer = ActionInitializerAttackSimple(
                      weapon: weapon,
                      target: target,
                      icon: t.icon,
                    );
                }

                Navigator.of(context, rootNavigator: true).pop(initializer);
              },
              child: Text(
                t.title,
              ),
            )
          );
        }
      case WeaponRange.distance:
        for(var t in CombatActionAttackDistanceType.values) {
          options.add(
            SimpleDialogOption(
              onPressed: () {
                ActionInitializerAttack initializer;
                switch(t) {
                  case CombatActionAttackDistanceType.simple:
                    initializer = ActionInitializerAttackSimple(
                      weapon: weapon,
                      target: target,
                      icon: t.icon,
                    );
                }

                Navigator.of(context, rootNavigator: true).pop(initializer);
              },
              child: Text(
                t.title,
              ),
            )
          );
        }
      case WeaponRange.ranged:
        for(var t in CombatActionAttackRangedType.values) {
          options.add(
            SimpleDialogOption(
              onPressed: () {
                ActionInitializerAttack initializer;
                switch(t) {
                  case CombatActionAttackRangedType.simple:
                    initializer = ActionInitializerAttackSimple(
                      weapon: weapon,
                      target: target,
                      icon: t.icon,
                    );
                }

                Navigator.of(context, rootNavigator: true).pop(initializer);
              },
              child: Text(
                t.title,
              ),
            )
          );
        }
    }

    if(options.isEmpty) {
      // TODO: display a message
      return;
    }

    var initializer = await showDialog<ActionInitializerAttack?>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text("Sélectionner le type d'attaque"),
        children: options,
      ),
    );
    if(!context.mounted) return;
    if(initializer == null) {
      // TODO: display a message
      return;
    }

    await initializer.plan(context, action);

    // TODO
  }
}