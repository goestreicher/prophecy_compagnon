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
import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/action_initializer.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/movement/get_up.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/movement/run.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/movement/simple.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/movement/sprint.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/encounter/turn/delay_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message_response.dart';
import 'package:prophecy_compagnon_shared/ui/entity/status_widget.dart';
import 'package:prophecy_compagnon_shared/ui/error_feedback.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/button_renderer.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/menu_renderer.dart';

class TurnActionWidget extends StatelessWidget {
  const TurnActionWidget({
    super.key,
    required this.action,
    this.isActive = false,
    this.onSetActive,
    this.locked = false,
  });

  final SessionEncounterEntityAction action;
  final bool isActive;
  final void Function()? onSetActive;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var controlling = SessionMessageBusClient.instance?.controlling(action.entity.id) ?? false;
    var bottomRow = <Widget>[];

    if(!action.entity.canAct()) {
      bottomRow.add(
        Text(
          'Action impossible',
          style: theme.textTheme.bodySmall,
        )
      );
    }
    else if(action.stage == SessionEncounterEntityActionStage.planned) {
      bottomRow.add(
        Text(
          'Action planifiée',
          style: theme.textTheme.bodySmall,
        )
      );
    }
    else if(action.stage == SessionEncounterEntityActionStage.approved) {
      bottomRow.add(
        Text(
          'Action prête',
          style: theme.textTheme.bodySmall,
        )
      );
    }
    else {
      if(locked) {
        bottomRow.add(
          Text(
            'Planification',
            style: theme.textTheme.bodySmall,
          )
        );
      }
      else if(!isActive) {
        bottomRow.add(
          Text(
            'Cliquer pour activer',
            style: theme.textTheme.bodySmall,
          )
        );
      }
      else {
        if(!controlling) {
          bottomRow.add(
            Text(
              'Action contrôlée par un autre client',
              style: theme.textTheme.bodySmall,
            )
          );
        }
        else if(action.stage == SessionEncounterEntityActionStage.none) {
          bottomRow.add(
            IconButton(
              icon: Icon(Icons.pause),
              iconSize: 18.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(),
              tooltip: "Retarder l'action",
              onPressed: () async {
                var messageBus = SessionMessageBusClient.instance;
                if(messageBus == null) {
                  await displayErrorDialog(
                    context,
                    "Pas de connexion au bus de messages",
                    "Aucune instance du bus de message n'a été trouvée, impossible de retarder l'action",
                  );
                  return;
                }

                var response = await messageBus.publishAndWaitForResponse(
                  SessionEncounterTurnDelayActionMessage(
                    destination: SessionMessage.masterIdentifier,
                    actionUuid: action.uuid,
                  )
                );
                if(!context.mounted) return;

                if(response.status != SessionMessageResponseStatus.accepted) {
                  await displayErrorDialog(
                    context,
                    "Planification non acceptée",
                    "Le décalage de l'action n'a pas été accepté (statut "
                    "${response.status}), la planification est abandonnée",
                  );
                  return;
                }
              },
            )
          );

          if(action.entity.canAct()) {
            var initializers = <ActionInitializer>[];

            /*
                Movement actions
             */
            if(action.entity.canMove()) {
              initializers.addAll([
                ActionInitializerMovementSimple(),
                ActionInitializerMovementRun(),
                ActionInitializerMovementSprint(),
              ]);
            }
            else if(
                action.entity.combatStatus.has(EntityCombatStatusFlag.onGround)
                && !action.entity.combatStatus.has(EntityCombatStatusFlag.grappled)
            ) {
              initializers.add(
                ActionInitializerMovementGetUp(),
              );
            }

            if(initializers.isNotEmpty) {
              bottomRow.add(
                _ActionTypeMenu(
                  type: CombatActionType.movement,
                  action: action,
                  items: initializers,
                  actionBuildContext: context,
                )
              );
            }

            /*
                Attack actions
             */
            initializers.clear();
            EquipableItemSlot hand;
            if(action.weakHand) {
              hand = EquipableItemSlot.weakHand;
            }
            else {
              hand = EquipableItemSlot.dominantHand;
            }

            for(var dp in action.entity.damageProviderForHand(hand)) {
              if(dp is! Weapon) {
                continue;
              }

              initializers.add(
                ActionInitializerWeapon(weapon: dp)
              );
            }

            if(initializers.isNotEmpty) {
              bottomRow.add(
                _ActionTypeMenu(
                  type: CombatActionType.attack,
                  action: action,
                  items: initializers,
                  actionBuildContext: context,
                )
              );
            }
          }
        }
        else if(action.stage == SessionEncounterEntityActionStage.assigned) {
          var initializer = action.combatAction?.initializer();

          if(initializer == null) {
            // TODO: propose to un-assign the action
            // Though some actions (effect) are without CombatActionDescription,
            // but in this case we shouldn't be in this branch
          }
          else {
            bottomRow.add(
              Row(
                spacing: 8.0,
                children: [
                  Text(
                    'Action assignée',
                    style: theme.textTheme.bodySmall,
                  ),
                  ActionConfigurationButtonRenderer(
                    action: action,
                    initializer: initializer,
                  )
                ],
              )
            );
          }
        }
      }
    }

    var child = InkWell(
      onTap: (isActive || locked) ? null : onSetActive,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8.0,
          children: [
            EntityStatusWidget(
              entity: action.entity,
              iconWidth: 40.0,
              iconHeight: 40.0
            ),
            Row(
              spacing: 8.0,
              children: bottomRow,
            ),
          ],
        )
      ),
    );

    if(isActive) {
      return Card(child: child);
    }
    else {
      return Card.filled(child: child);
    }
  }
}

class _ActionTypeMenu extends StatelessWidget {
  const _ActionTypeMenu({
    required this.type,
    required this.action,
    required this.items,
    required this.actionBuildContext,
  });

  final CombatActionType type;
  final SessionEncounterEntityAction action;
  final List<ActionInitializer> items;
  final BuildContext actionBuildContext;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        for(var i in items)
          ActionConfigurationMenuRenderer(
            action: action,
            initializer: i,
            actionBuildContext: actionBuildContext,
          ),
      ],
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: Icon(type.icon),
          iconSize: 18.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
          tooltip: type.title,
          onPressed: () {
            if(controller.isOpen) {
              controller.close();
            }
            else {
              controller.open();
            }
          }
        );
      },
    );
  }
}