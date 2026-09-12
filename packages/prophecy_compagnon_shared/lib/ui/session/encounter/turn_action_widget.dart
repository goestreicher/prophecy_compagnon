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
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_description.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/descriptions/finder.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/ui/entity/pill_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/button_renderer.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/menu_renderer.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/encounter/turn/delay_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/session_message_response.dart';

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

    if(action.stage == SessionEncounterEntityActionStage.planned) {
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
      if(!isActive) {
        bottomRow.add(
          Text(
            'Cliquer pour activer',
            style: theme.textTheme.bodySmall,
          )
        );
      }
      else {
        if(action.stage == SessionEncounterEntityActionStage.none) {
          if(controlling) {
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
                    // TODO: display a message
                    return;
                  }

                  var response = await messageBus.publishAndWaitForResponse(
                    SessionEncounterTurnDelayActionMessage(
                      destination: SessionMessage.masterIdentifier,
                      actionUuid: action.uuid,
                    )
                  );

                  if(response.status != SessionMessageResponseStatus.accepted) {
                    // TODO: display a message
                    return;
                  }
                },
              )
            );

            if(action.canBeUsedFor(CombatActionType.movement)) {
              var descriptions = action.entity.availableActionsForType(CombatActionType.movement);
              if(descriptions.isNotEmpty) {
                bottomRow.add(
                  _ActionTypeMenu(
                    type: CombatActionType.movement,
                    action: action,
                    items: descriptions,
                  )
                );
              }
            }
          }
          else {
            bottomRow.add(
              Text(
                'Action contrôlée par un autre client',
                style: theme.textTheme.bodySmall,
              )
            );
          }
        }
        else if (action.stage == SessionEncounterEntityActionStage.assigned) {
          var actionDescription = action.combatAction == null
              ? null
              : actionDescriptionForCombatAction(action.combatAction!);

          if(actionDescription == null) {
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
                    actionConfiguration: actionDescription.instantiate(),
                  )
                ],
              )
            );
          }
        }
      }
    }

    var combatStatuses = <String>[];
    for(var s in EntityCombatStatusFlag.values) {
      if(action.entity.combatStatus.has(s)) {
        combatStatuses.add(s.label);
      }
    }

    var child = InkWell(
      onTap: (isActive || locked) ? null : onSetActive,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8.0,
          children: [
            Row(
              spacing: 8.0,
              children: [
                EntityPillWidget(
                  entity: action.entity,
                  width: 40,
                  height: 40,
                ),
                Column(
                  children: [
                    Text(
                      action.entity.name,
                      style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    ),
                    if(combatStatuses.isNotEmpty)
                      Text(
                        'Statut de combat : ${combatStatuses.join(", ")}',
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ],
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
  });

  final CombatActionType type;
  final SessionEncounterEntityAction action;
  final List<CombatActionDescription> items;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        for(var i in items)
          ActionConfigurationMenuRenderer(
            action: action,
            actionConfiguration: i.instantiate(),
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