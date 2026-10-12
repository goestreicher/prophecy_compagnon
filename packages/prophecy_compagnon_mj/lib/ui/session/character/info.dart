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
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/entity/specialized_skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart';
import 'package:prophecy_compagnon_shared/ui/character/base/display_secondary_attributes_widget.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/display_abilities_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/display_attributes_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/injury_manager_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/status_widget.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
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
          _SkillThrowsMenuWidget(
            entity: character,
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

abstract class _SkillThrowWrapper {
  _SkillThrowWrapper();
}

class _SeparatorSkillThrowWrapper extends _SkillThrowWrapper {
  _SeparatorSkillThrowWrapper();
}

class _StandardSkillThrowWrapper extends _SkillThrowWrapper {
  _StandardSkillThrowWrapper({
    required this.skill,
    this.implementation,
  });

  final Skill skill;
  final String? implementation;
}

class _SpecializationSkillThrowWrapper extends _SkillThrowWrapper {
  _SpecializationSkillThrowWrapper({
    required this.specialization,
  });

  final SpecializedSkill specialization;
}

class _SkillThrowsMenuWidget extends StatefulWidget {
  const _SkillThrowsMenuWidget({
    required this.entity,
  });

  final EntityBase entity;

  @override
  State<_SkillThrowsMenuWidget> createState() => _SkillThrowsMenuWidgetState();
}

class _SkillThrowsMenuWidgetState extends State<_SkillThrowsMenuWidget> {
  _SkillThrowWrapper? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var entries = <DropdownMenuEntry<_SkillThrowWrapper>>[];
    for(var family in SkillFamily.values) {
      var familyEntries = <DropdownMenuEntry<_SkillThrowWrapper>>[];

      for(var skill in widget.entity.skills.forFamily(family)) {
        familyEntries.add(
          DropdownMenuEntry(
            value: _StandardSkillThrowWrapper(
              skill: skill.skill,
              implementation: skill.implementation,
            ),
            label: skill.title,
          )
        );

        for(var specialization in skill.specializations) {
          familyEntries.add(
            DropdownMenuEntry(
              value: _SpecializationSkillThrowWrapper(
                specialization: specialization.skill,
              ),
              label: '  - ${specialization.skill.name}',
            )
          );
        }
      }

      if(familyEntries.isNotEmpty) {
        entries.addAll([
          DropdownMenuEntry(
            enabled: false,
            value: _SeparatorSkillThrowWrapper(),
            label: '---- ${family.title}',
            labelWidget: Row(
              children: [
                Expanded(
                  child: const Divider(
                    endIndent: 8.0,
                  )
                ),
                Text(family.title),
                Expanded(
                  child: const Divider(
                    indent: 8.0,
                  )
                )
              ],
            ),
          ),
          ...familyEntries,
        ]);
      }
    }

    if(entries.isEmpty) {
      return SizedBox.shrink();
    }

    return Row(
      spacing: 8.0,
      children: [
        Expanded(
          child: DropdownMenu(
            label: Text(
              'Jet de compétence',
            ),
            textStyle: theme.textTheme.bodySmall,
            expandedInsets: EdgeInsets.zero,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            onSelected: (_SkillThrowWrapper? w) {
              setState(() {
                selected = w;
              });
            },
            dropdownMenuEntries: entries,
          ),
        ),
        IconButton(
          onPressed: selected == null ? null : () async {
            var result = await showDialog<_PrepareSkillThrowResult>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => _PrepareSkillThrowDialog(),
            );
            if(result == null) return;
            if(!context.mounted) return;

            DiceThrowEntityBaseSkill base;
            if(selected is _StandardSkillThrowWrapper) {
              base = DiceThrowEntityBaseSkill(
                attribute: result.attribute,
                skill: (selected as _StandardSkillThrowWrapper).skill,
                implementation: (selected as _StandardSkillThrowWrapper).implementation,
              );
            }
            else {
              base = DiceThrowEntityBaseSkill(
                attribute: result.attribute,
                specialization: (selected as _SpecializationSkillThrowWrapper).specialization,
                implementation: (selected as _SpecializationSkillThrowWrapper).specialization.parentImplementation,
              );
            }

            var request = DiceThrowRequest(
              type: DiceThrowRequestType.simple,
              context: DiceThrowRequestContext.none,
              difficulty: result.difficulty,
              base: base,
            );

            var bundles = await showDialog<List<EntityThrowBundle>>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => EntityDiceThrowDialog(
                entities: [widget.entity],
                request: request,
                canChangeDifficulty: true,
              )
            );
            if(bundles == null || bundles.isEmpty) return;
            if(!context.mounted) return;

            var evaluation = evaluateDiceThrow(bundles.first);
          },
          icon: Icon(CustomIcons.d10),
        )
      ],
    );
  }
}

class _PrepareSkillThrowResult {
  const _PrepareSkillThrowResult({
    required this.attribute,
    this.difficulty,
  });

  final Attribute attribute;
  final int? difficulty;
}

class _PrepareSkillThrowDialog extends StatefulWidget {
  const _PrepareSkillThrowDialog();

  @override
  State<_PrepareSkillThrowDialog> createState() => _PrepareSkillThrowDialogState();
}

class _PrepareSkillThrowDialogState extends State<_PrepareSkillThrowDialog> {
  Attribute? attribute;
  bool setDifficulty = false;
  int difficulty = 15;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Configuration du jet'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            DropdownMenu(
              label: const Text('Attribut'),
              expandedInsets: EdgeInsets.zero,
              initialSelection: attribute,
              dropdownMenuEntries: Attribute.values
                .map((Attribute a) => DropdownMenuEntry(value: a, label: a.title))
                .toList(),
              onSelected: (Attribute? a) {
                setState(() {
                  attribute = a;
                });
              },
            ),
            Row(
              spacing: 8.0,
              children: [
                Switch(
                  value: setDifficulty,
                  onChanged: (bool v) {
                    setState(() {
                      setDifficulty = v;
                    });
                  },
                ),
                Text(
                  'Difficulté',
                  style: TextStyle(
                    color: setDifficulty ? null : theme.disabledColor,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 70,
                  child: NumIntInputWidget(
                    enabled: setDifficulty,
                    initialValue: difficulty,
                    minValue: 0,
                    maxValue: 99,
                    onChanged: (int v) {
                      setState(() {
                        difficulty = v;
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: attribute == null
            ? null
            : () {
                Navigator.of(context, rootNavigator: true).pop(
                  _PrepareSkillThrowResult(
                    attribute: attribute!,
                    difficulty: setDifficulty ? difficulty : null,
                  )
                );
              },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('OK'),
        ),
      ],
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