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
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/injury_manager_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/status_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class SessionCharacterInfoWidget extends StatelessWidget {
  const SessionCharacterInfoWidget({
    super.key,
    required this.character,
  });

  final PlayerCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Column(
              spacing: 16.0,
              children: [
                EntityStatusWidget(
                  entity: character,
                  iconWidth: 50.0,
                  iconHeight: 50.0,
                ),
                EntityInjuryManagerWidget(
                  manager: character.injuries.manager,
                ),
              ],
            ),
            WidgetGroupContainer(
              title: Text('Actions'),
              titleBackgroundColor: theme.colorScheme.surfaceContainerLow,
              child: Column(
                spacing: 8.0,
                children: [
                  _DiceThrowMenuWidget(
                    entity: character,
                    items: _sharedDiceThrowMenuItems,
                  ),
                  _EffectsMenuWidget(
                    entity: character,
                  ),
                ],
              )
            ),
          ],
        )
      ),
    );
  }
}

class _DiceThrowMenuItem {
  const _DiceThrowMenuItem({
    required this.label,
    required this.request,
    this.canChangeDifficulty = true,
    this.difficultyHints,
    this.contextModifierHints,
  });

  final String label;
  final DiceThrowRequest request;
  final bool canChangeDifficulty;
  final Map<String, int>? difficultyHints;
  final List<String>? contextModifierHints;
}

class _DiceThrowMenuWidget extends StatefulWidget {
  const _DiceThrowMenuWidget({
    required this.entity,
    required this.items,
  });

  final EntityBase entity;
  final List<_DiceThrowMenuItem> items;

  @override
  State<_DiceThrowMenuWidget> createState() => _DiceThrowMenuWidgetState();
}

class _DiceThrowMenuWidgetState extends State<_DiceThrowMenuWidget> {
  _DiceThrowMenuItem? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        spacing: 8.0,
        children: [
          DropdownMenu(
            label: Text(
              'Jets',
            ),
            onSelected: (_DiceThrowMenuItem? i) {
              setState(() {
                selected = i;
              });
            },
            dropdownMenuEntries: widget.items.map(
                (_DiceThrowMenuItem i) => DropdownMenuEntry(value: i, label: i.label)
              )
              .toList(),
          ),
          IconButton(
            onPressed: selected == null ? null : () async {
              var bundle = await showDialog<EntityThrowBundle>(
                context: context,
                builder: (BuildContext context) => EntityDiceThrowDialog(
                  entity: widget.entity,
                  request: selected!.request,
                  canChangeDifficulty: selected!.canChangeDifficulty,
                  difficultyHints: selected!.difficultyHints,
                  contextModifierHints: selected!.contextModifierHints,
                )
              );
            },
            icon: Icon(CustomIcons.d10),
          ),
        ],
      ),
    );
  }
}

final _sharedDiceThrowMenuItems = [
  _DiceThrowMenuItem(
    label: 'Discrétion',
    canChangeDifficulty: true,
    request: DiceThrowRequest(
      type: DiceThrowRequestType.simple,
      context: DiceThrowRequestContext.discretion,
      difficulty: 15,
      base: DiceThrowEntityBaseSkill(
        attribute: Attribute.physique,
        skill: Skill.discretion,
        ability: Ability.coordination,
      ),
    ),
  ),
  for(var attr in [Attribute.mental, Attribute.manuel])
    _DiceThrowMenuItem(
      label: 'Perception (${attr.title})',
      canChangeDifficulty: true,
      request: DiceThrowRequest(
        type: DiceThrowRequestType.simple,
        context: DiceThrowRequestContext.perception,
        difficulty: 15,
        base: DiceThrowEntityBaseAbility(
          attribute: attr,
          ability: Ability.perception,
        ),
      ),
      difficultyHints: {
        'Cible de grande taille ou très bruyante': 10,
        "La cible manque d'évidence sans être précisément dissimulée": 15,
        "La cible prend soin de se cacher ou a été cachée rapidement": 20,
        "La cible est minuscule ou presque invisible": 25,
        "La cible est indétectable sans recherche poussée": 30,
        "La cible est indétectable par un humain non averti": 35,
      },
      contextModifierHints: _perceptionContextModifierHints,
    ),
];

const _perceptionContextModifierHints = [
  "Personnage en alerte : +1 à +4",
  "Personnage attentif : +1 à +3",
  "Personnage fatigué, distrait : -1 à -2",
  "En pleine agitation : -1 à -3",
  "En plein chaos : -3 à -5",
  "Recherche à la hâte : -1 à -3",
  "Recherche soigneuse : +1 à +3",
  "Mauvaise visibilité : -1 à -5",
  "Dans l'obscurité presque totale : -10",
];

class _EffectsMenuWidget extends StatefulWidget {
  const _EffectsMenuWidget({
    required this.entity,
  });

  final EntityBase entity;

  @override
  State<_EffectsMenuWidget> createState() => _EffectsMenuWidgetState();
}

class _EffectsMenuWidgetState extends State<_EffectsMenuWidget> {
  EntityEffect? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        spacing: 8.0,
        children: [
          DropdownMenu(
            label: Text(
              'Effets',
            ),
            onSelected: (EntityEffect? e) {
              setState(() {
                selected = e;
              });
            },
            dropdownMenuEntries: widget.entity.effects.map(
                (EntityEffect e) => DropdownMenuEntry(value: e, label: e.name)
              )
              .toList(),
          ),
          IconButton(
            onPressed: selected == null ? null : () async {
              if(selected!.active) {
                SessionMessageBusClient.instance?.publish(
                  SessionEntityUnapplyEffectMessage(
                    broadcastIncludesSelf: true,
                    entityId: widget.entity.id,
                    effectId: selected!.id,
                  )
                );
              }
              else {
                DiceThrowEvaluation? activationDiceThrowEvaluation;

                if (selected!.activationDiceThrowRequest != null) {
                  var bundle = await showDialog<EntityThrowBundle>(
                    context: context,
                    builder: (BuildContext context) =>
                      EntityDiceThrowDialog(
                        entity: widget.entity,
                        request: selected!.activationDiceThrowRequest!,
                      )
                  );
                  if(bundle == null) return;
                  if(!context.mounted) return;

                  activationDiceThrowEvaluation = evaluateDiceThrow(bundle);
                  if(!selected!.canApply(target: widget.entity, activationDiceThrowEvaluation: activationDiceThrowEvaluation)) {
                    // TODO: display a message?
                    return;
                  }
                }

                SessionMessageBusClient.instance?.publish(
                  SessionEntityAddEffectMessage(
                    broadcastIncludesSelf: true,
                    entityId: widget.entity.id,
                    effect: selected!,
                    activationDiceThrowEvaluation: activationDiceThrowEvaluation,
                  )
                );
              }

              setState(() {
                // no-op, required to have the button redraw if the effect
                // activation has changed
              });
            },
            tooltip: (selected?.active ?? false)
              ? 'Désactiver'
              : 'Activer',
            icon: (selected?.active ?? false)
              ? Icon(Icons.close)
              : Icon(Icons.arrow_forward),
          )
        ],
      )
    );
  }
}