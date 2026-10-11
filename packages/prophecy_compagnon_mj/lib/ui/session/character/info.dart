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
import 'package:prophecy_compagnon_mj/ui/session/character/dice_throw_menu_item.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/shared_dice_throw_items.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart';
import 'package:prophecy_compagnon_shared/ui/character/base/display_secondary_attributes_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/display_abilities_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/display_attributes_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/injury_manager_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/status_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class SessionCharacterInfoWidget extends StatefulWidget {
  const SessionCharacterInfoWidget({
    super.key,
    required this.character,
  });

  final EntityBase character;

  @override
  State<SessionCharacterInfoWidget> createState() => _SessionCharacterInfoWidgetState();
}

class _SessionCharacterInfoWidgetState extends State<SessionCharacterInfoWidget> {
  _SessionCharacterInfoSelectedView selectedView = _SessionCharacterInfoSelectedView.actions;

  @override
  Widget build(BuildContext context) {
    Widget? viewWidget;
    switch(selectedView) {
      case _SessionCharacterInfoSelectedView.actions:
        viewWidget = _SessionCharacterInfoViewActions(
          character: widget.character
        );
      case _SessionCharacterInfoSelectedView.injuries:
        viewWidget = _SessionCharacterInfoViewInjuries(
          character: widget.character
        );
      case _SessionCharacterInfoSelectedView.attributes:
        viewWidget = _SessionCharacterInfoViewAttributes(
          character: widget.character
        );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Column(
                spacing: 16.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: EntityStatusWidget(
                      entity: widget.character,
                      iconWidth: 50.0,
                      iconHeight: 50.0,
                    ),
                  ),
                  ListBody(
                    children: [
                      _SessionCharacterInfoSelectViewWidget(
                        view: _SessionCharacterInfoSelectedView.actions,
                        selected: selectedView == _SessionCharacterInfoSelectedView.actions,
                        onSelected: () {
                          setState(() {
                            selectedView = _SessionCharacterInfoSelectedView.actions;
                          });
                        },
                      ),
                      _SessionCharacterInfoSelectViewWidget(
                        view: _SessionCharacterInfoSelectedView.injuries,
                        selected: selectedView == _SessionCharacterInfoSelectedView.injuries,
                        onSelected: () {
                          setState(() {
                            selectedView = _SessionCharacterInfoSelectedView.injuries;
                          });
                        },
                      ),
                      _SessionCharacterInfoSelectViewWidget(
                        view: _SessionCharacterInfoSelectedView.attributes,
                        selected: selectedView == _SessionCharacterInfoSelectedView.attributes,
                        onSelected: () {
                          setState(() {
                            selectedView = _SessionCharacterInfoSelectedView.attributes;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: viewWidget),
          ],
        )
      ),
    );
  }
}

enum _SessionCharacterInfoSelectedView {
  actions(title: 'Actions'),
  injuries(title: 'Blessures'),
  attributes(title: 'Attributs'),
  ;

  final String title;

  const _SessionCharacterInfoSelectedView({ required this.title });
}

class _SessionCharacterInfoSelectViewWidget extends StatelessWidget {
  const _SessionCharacterInfoSelectViewWidget({
    required this.view,
    required this.selected,
    required this.onSelected,
  });

  final _SessionCharacterInfoSelectedView view;
  final bool selected;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: selected ? null : onSelected,
      child: Container(
        color: selected
            ? theme.colorScheme.surfaceContainerHighest
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            view.title,
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }
}

class _SessionCharacterInfoViewActions extends StatelessWidget {
  const _SessionCharacterInfoViewActions({
    required this.character,
  });

  final EntityBase character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text('Actions'),
      titleBackgroundColor: theme.colorScheme.surfaceContainerLow,
      child: Column(
        spacing: 8.0,
        children: [
          DiceThrowMenuWidget(
            label: 'Jets communs',
            entities: [character],
            items: [
              ...sharedDiceThrowItems['perception']!,
              ...sharedDiceThrowItems['discretion']!,
              ...sharedDiceThrowItems['luck']!,
            ],
          ),
          if(character.effects.isNotEmpty)
            _EffectsMenuWidget(
              entity: character,
            ),
        ],
      )
    );
  }
}

class _SessionCharacterInfoViewInjuries extends StatelessWidget {
  const _SessionCharacterInfoViewInjuries({
    required this.character,
  });

  final EntityBase character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text('Blessures'),
      titleBackgroundColor: theme.colorScheme.surfaceContainerLow,
      child: EntityInjuryManagerWidget(
        manager: character.injuries.manager,
      ),
    );
  }
}

class _SessionCharacterInfoViewAttributes extends StatelessWidget {
  const _SessionCharacterInfoViewAttributes({
    required this.character,
  });

  final EntityBase character;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      child: Column(
        spacing: 16.0,
        children: [
          EntityDisplayAbilitiesWidget(
            entity: character
          ),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: EntityDisplayAttributesWidget(
                  entity: character
                ),
              ),
              if(character is HumanCharacter)
                Expanded(
                  child: CharacterDisplaySecondaryAttributesWidget(
                    character: character as HumanCharacter,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

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
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        spacing: 8.0,
        children: [
          DropdownMenu(
            label: Text(
              'Effets',
            ),
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            onSelected: (EntityEffect? e) {
              setState(() {
                selected = e;
              });
            },
            dropdownMenuEntries: widget.entity.effects
              .where((EntityEffect e) => e.trigger == EntityEffectTrigger.request)
              .map(
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
                  var bundles = await showDialog<List<EntityThrowBundle>>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) =>
                      EntityDiceThrowDialog(
                        entities: [widget.entity],
                        request: selected!.activationDiceThrowRequest!,
                      )
                  );
                  if(bundles == null || bundles.isEmpty) return;
                  if(!context.mounted) return;

                  activationDiceThrowEvaluation = evaluateDiceThrow(bundles.first);
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