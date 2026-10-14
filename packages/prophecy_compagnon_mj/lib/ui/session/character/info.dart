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
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/ability.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/entity/specialized_skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/status/entity_effect.dart';
import 'package:prophecy_compagnon_shared/ui/character/base/display_secondary_attributes_widget.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/display_abilities_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/display_attributes_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/injury_manager_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/pill_widget.dart';
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
          _AbilityThrowMenuWidget(
            entities: [character],
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

class _SkillThrowWrapperToBaseArgs {
  _SkillThrowWrapperToBaseArgs({
    required this.attribute,
    this.fallbackAbility,
  });

  Attribute attribute;
  Ability? fallbackAbility;
}

abstract class _SkillThrowWrapper {
  _SkillThrowWrapper();

  DiceThrowEntityBase toBase(_SkillThrowWrapperToBaseArgs args);
}

class _SeparatorSkillThrowWrapper extends _SkillThrowWrapper {
  _SeparatorSkillThrowWrapper();

  @override
  DiceThrowEntityBase toBase(_SkillThrowWrapperToBaseArgs args) {
    throw UnimplementedError();
  }
}

class _StandardSkillThrowWrapper extends _SkillThrowWrapper {
  _StandardSkillThrowWrapper({
    required this.skill,
    this.implementation,
  });

  final Skill skill;
  final String? implementation;

  @override
  DiceThrowEntityBase toBase(_SkillThrowWrapperToBaseArgs args) => DiceThrowEntityBaseSkill(
    attribute: args.attribute,
    skill: skill,
    implementation: implementation,
    ability: args.fallbackAbility,
  );
}

class _SpecializationSkillThrowWrapper extends _SkillThrowWrapper {
  _SpecializationSkillThrowWrapper({
    required this.specialization,
  });

  final SpecializedSkill specialization;

  @override
  DiceThrowEntityBase toBase(_SkillThrowWrapperToBaseArgs args) => DiceThrowEntityBaseSkill(
    attribute: args.attribute,
    specialization: specialization,
    implementation: specialization.parentImplementation,
    ability: args.fallbackAbility,
  );
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
              builder: (BuildContext context) => _PrepareSkillThrowDialog(
                actors: [widget.entity],
              ),
            );
            if(result == null) return;
            if(!context.mounted) return;

            var entities = <EntityBase>[];

            var request = DiceThrowRequest(
              type: result.requestType,
              context: DiceThrowRequestContext.none,
              difficulty: result.difficulty,
              base: selected!.toBase(
                _SkillThrowWrapperToBaseArgs(
                  attribute: result.attribute,
                  fallbackAbility: result.fallbackAbility,
                )
              ),
            );

            DiceThrowRequest? opposingRequest;
            if(result.isOpposition) {
              entities = [widget.entity, result.opposing!];
              if(result.opposingBase != null) {
                opposingRequest = DiceThrowRequest(
                  type: result.requestType,
                  context: DiceThrowRequestContext.none,
                  difficulty: result.difficulty,
                  base: result.opposingBase!,
                );
              }
            }
            else {
              entities = [widget.entity];
            }

            var bundles = await showDialog<List<EntityThrowBundle>>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => EntityDiceThrowDialog(
                entities: entities,
                request: request,
                opposingRequest: opposingRequest,
                canChangeDifficulty: true,
              )
            );
            if(bundles == null || bundles.isEmpty) return;
            if(!context.mounted) return;

            if(result.isOpposition) {
              var evaluation = evaluateDiceThrow(bundles[0], opposing: bundles[1]);
            }
            else if(result.difficulty != null) {
              var evaluation = evaluateDiceThrow(bundles.first);
            }
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
    required this.requestType,
    this.opposing,
    this.opposingBase,
    this.fallbackAbility,
  });

  final Attribute attribute;
  final int? difficulty;
  final DiceThrowRequestType requestType;
  final EntityBase? opposing;
  final DiceThrowEntityBase? opposingBase;
  final Ability? fallbackAbility;

  bool get isOpposition =>
      requestType == DiceThrowRequestType.oppositionNR
      || requestType == DiceThrowRequestType.oppositionDirect;
}

class _PrepareSkillThrowDialog extends StatefulWidget {
  const _PrepareSkillThrowDialog({
    required this.actors,
  });

  final List<EntityBase> actors;

  @override
  State<_PrepareSkillThrowDialog> createState() => _PrepareSkillThrowDialogState();
}

class _PrepareSkillThrowDialogState extends State<_PrepareSkillThrowDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Attribute? attribute;
  bool setDifficulty = true;
  int difficulty = 15;
  bool isOpposition = false;
  DiceThrowRequestType requestType = DiceThrowRequestType.simple;
  EntityBase? opposing;
  DiceThrowEntityBase? opposingBase;
  Ability? fallbackActivity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Configuration du jet'),
      content: SizedBox(
        width: 300,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: [
              DropdownMenuFormField(
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
                validator: (Attribute? a) {
                  if(a == null) return "Attribut requis";
                  return null;
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
              ),
              if(widget.actors.length == 1)
                Row(
                  spacing: 8.0,
                  children: [
                    Switch(
                      value: isOpposition,
                      onChanged: (bool v) {
                        setState(() {
                          isOpposition = v;
                          if(!v) {
                            requestType = DiceThrowRequestType.simple;
                            opposing = null;
                            opposingBase = null;
                          }
                          else {
                            requestType = DiceThrowRequestType.oppositionNR;
                          }
                        });
                      },
                    ),
                    Text(
                      "Jet d'opposition",
                      style: TextStyle(
                        color: isOpposition ? null : theme.disabledColor,
                      ),
                    ),
                  ],
                ),
                if(isOpposition)
                  DropdownMenu(
                    label: const Text("Type d'opposition"),
                    expandedInsets: EdgeInsets.zero,
                    initialSelection: requestType,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: DiceThrowRequestType.oppositionNR, label: "Comparer les NR"),
                      DropdownMenuEntry(value: DiceThrowRequestType.oppositionDirect, label: "Comparer les marges"),
                    ],
                    onSelected: (DiceThrowRequestType? t) {
                      if(t == null) return;

                      setState(() {
                        requestType = t;
                      });
                    },
                  ),
                if(isOpposition)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: _PrepareSkillThrowOppositionWidget(
                      actor: widget.actors.first,
                      onEntitySelected: (EntityBase e) {
                        setState(() {
                          opposing = e;
                        });
                      },
                      onBaseSelected: (DiceThrowEntityBase? b) {
                        opposingBase = b;
                      },
                      onFallbackAbilitySelected: (Ability? a) {
                        fallbackActivity = a;
                      },
                    ),
                  ),
            ],
          ),
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
          onPressed: isOpposition && opposing == null ? null : () {
            if(!formKey.currentState!.validate()) return;

            Navigator.of(context, rootNavigator: true).pop(
              _PrepareSkillThrowResult(
                attribute: attribute!,
                difficulty: setDifficulty ? difficulty : null,
                requestType: requestType,
                opposing: opposing,
                opposingBase: opposingBase,
                fallbackAbility: fallbackActivity,
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

class _PrepareSkillThrowOppositionWidget extends StatefulWidget {
  const _PrepareSkillThrowOppositionWidget({
    required this.actor,
    required this.onEntitySelected,
    required this.onBaseSelected,
    required this.onFallbackAbilitySelected,
  });

  final EntityBase actor;
  final void Function(EntityBase) onEntitySelected;
  final void Function(DiceThrowEntityBase?) onBaseSelected;
  final void Function(Ability?) onFallbackAbilitySelected;

  @override
  State<_PrepareSkillThrowOppositionWidget> createState() => _PrepareSkillThrowOppositionWidgetState();
}

class _PrepareSkillThrowOppositionWidgetState extends State<_PrepareSkillThrowOppositionWidget> {
  EntityBase? opposing;
  _OpposingRequestType requestType = _OpposingRequestType.identical;
  bool requireFallbackAbility = true;
  Ability? fallbackAbility;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget? opposingRequestConfigurationWidget;
    if(opposing != null) {
      switch(requestType) {
        case _OpposingRequestType.identical:
          opposingRequestConfigurationWidget = SizedBox.shrink();
        case _OpposingRequestType.ability:
          opposingRequestConfigurationWidget = Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _OpposingRequestTypeAbilityWidget(
              onBaseSet: (DiceThrowEntityBase? base) {
                widget.onBaseSelected(base);
              }
            ),
          );
        case _OpposingRequestType.skill:
          opposingRequestConfigurationWidget = Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _OpposingRequestTypeSkillWidget(
              entity: opposing!,
              onBaseSet: (DiceThrowEntityBase? base) {
                widget.onBaseSelected(base);
              },
              fallbackAbility: fallbackAbility,
              onFallbackAbilityRequiredChanged: (bool v) {
                setState(() {
                  requireFallbackAbility = v;
                });
              },
            ),
          );
      }
    }

    return Column(
      spacing: 16.0,
      children: [
        Row(
          spacing: 8.0,
          children: [
            if(opposing != null)
              Row(
                spacing: 8.0,
                children: [
                  EntityPillWidget(
                    entity: opposing!,
                    width: 30.0,
                    height: 30.0,
                  ),
                  Text(
                    opposing!.name,
                  ),
                ],
              ),
            if(opposing == null)
              ElevatedButton(
                onPressed: () async {
                  var selected = await showDialog<EntityBase?>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) =>
                      _OpposingEntitySelectDialog(actor: widget.actor),
                  );
                  if(selected == null) return;
                  if(!context.mounted) return;

                  setState(() {
                    opposing = selected;
                  });
                  widget.onEntitySelected(selected);
                },
                child: Text(
                  opposing == null
                    ? "Choisir l'opposant"
                    : "Changer d'opposant",
                ),
              ),
          ],
        ),
        if(opposing != null)
          DropdownMenu(
            label: const Text('Type de jet'),
            textStyle: theme.textTheme.bodySmall,
            expandedInsets: EdgeInsets.zero,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            initialSelection: requestType,
            dropdownMenuEntries: _OpposingRequestType.values
              .map((_OpposingRequestType t) => DropdownMenuEntry(value: t, label: t.title))
              .toList(),
            onSelected: (_OpposingRequestType? t) {
              if(t == null) return;
              setState(() {
                requestType = t;

                switch(requestType) {
                  case _OpposingRequestType.identical:
                    requireFallbackAbility = true;
                  case _OpposingRequestType.skill:
                  case _OpposingRequestType.ability:
                    requireFallbackAbility = false;
                }
              });
            },
          ),
        ?opposingRequestConfigurationWidget,
        if(opposing != null && requireFallbackAbility)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownMenuFormField(
              label: const Text('Caractéristique de repli'),
              textStyle: theme.textTheme.bodySmall,
              expandedInsets: EdgeInsets.zero,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isCollapsed: true,
                constraints: BoxConstraints(maxHeight: 36.0),
                contentPadding: EdgeInsets.all(12.0),
              ),
              dropdownMenuEntries: Ability.values
                  .map((Ability a) => DropdownMenuEntry(value: a, label: a.title))
                  .toList(),
              onSelected: (Ability? a) {
                setState(() {
                  fallbackAbility = a;
                });
                widget.onFallbackAbilitySelected(a);
              },
              validator: (Ability? a) {
                if(a == null) return "Caractéristique requise";
                return null;
              },
            ),
          ),
      ],
    );
  }
}

class _OpposingEntitySelectDialog extends StatelessWidget {
  const _OpposingEntitySelectDialog({
    required this.actor,
  });

  final EntityBase actor;

  @override
  Widget build(BuildContext context) {
    var pcOptions = <Widget>[
      Row(
        spacing: 8.0,
        children: [
          Expanded(
            child: const Divider(
              indent: 16.0,
            )
          ),
          Text('PJs'),
          Expanded(
            child: const Divider(
              endIndent: 16.0,
            )
          ),
        ],
      )
    ];
    for(var e in GameSession.instance!.table.players) {
      if(e.id == actor.id) continue;
      pcOptions.add(
        _OpposingEntitySelectDialogOption(entity: e)
      );
    }

    var encounterOptions = <Widget>[];
    for(var e in (GameSession.instance!.encounter.value?.npcs ?? <EntityBase>[])) {
      if(e.id == actor.id) continue;
      encounterOptions.add(
        _OpposingEntitySelectDialogOption(entity: e)
      );
    }
    if(encounterOptions.isNotEmpty) {
      encounterOptions.insert(
        0,
        Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: const Divider(
                indent: 16.0,
              )
            ),
            Text('PNJs de la rencontre'),
            Expanded(
              child: const Divider(
                endIndent: 16.0,
              )
            ),
          ],
        )
      );
    }

    var scenarioOptions = <Widget>[];
    for(var e in (GameSession.instance!.scenario?.entities() ?? <EntityBase>[])) {
      if(e.id == actor.id) continue;
      scenarioOptions.add(
        _OpposingEntitySelectDialogOption(entity: e)
      );
    }
    if(scenarioOptions.isNotEmpty) {
      scenarioOptions.insert(
        0,
        Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: const Divider(
                indent: 16.0,
              )
            ),
            Text('PNJs du scénario'),
            Expanded(
              child: const Divider(
                endIndent: 16.0,
              )
            ),
          ],
        )
      );
    }

    return SimpleDialog(
      title: const Text("Choix de l'opposant"),
      children: [
        ...pcOptions,
        ...encounterOptions,
        ...scenarioOptions,
      ],
    );
  }
}

class _OpposingEntitySelectDialogOption extends StatelessWidget {
  const _OpposingEntitySelectDialogOption({
    required this.entity,
  });
  
  final EntityBase entity;
  
  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(entity);
      },
      child: Row(
        spacing: 8.0,
        children: [
          EntityPillWidget(
            entity: entity,
            width: 30.0,
            height: 30.0,
          ),
          Expanded(
            child: Text(
              entity.name,
            ),
          ),
        ],
      ),
    );
  }
}

enum _OpposingRequestType {
  identical(title: "Identique au jet principal"),
  skill(title: "Compétence"),
  ability(title: "Caractéristique"),
  ;

  final String title;

  const _OpposingRequestType({ required this.title });
}

class _OpposingRequestTypeSkillWidget extends StatefulWidget {
  const _OpposingRequestTypeSkillWidget({
    required this.entity,
    required this.onBaseSet,
    required this.onFallbackAbilityRequiredChanged,
    this.fallbackAbility,
  });

  final EntityBase entity;
  final void Function(DiceThrowEntityBase?) onBaseSet;
  final void Function(bool) onFallbackAbilityRequiredChanged;
  final Ability? fallbackAbility;

  @override
  State<_OpposingRequestTypeSkillWidget> createState() => _OpposingRequestTypeSkillWidgetState();
}

class _OpposingRequestTypeSkillWidgetState extends State<_OpposingRequestTypeSkillWidget> {
  Attribute? attribute;
  bool useEntitySkills = true;
  _SkillThrowWrapper? selected;

  void notifyBase() {
    if(attribute == null || selected == null) {
      widget.onBaseSet(null);
    }
    else {
      widget.onBaseSet(
        selected!.toBase(
          _SkillThrowWrapperToBaseArgs(
            attribute: attribute!,
            fallbackAbility: widget.fallbackAbility,
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var entries = <DropdownMenuEntry<_SkillThrowWrapper>>[];
    for(var family in SkillFamily.values) {
      var familyEntries = <DropdownMenuEntry<_SkillThrowWrapper>>[];

      if(useEntitySkills) {
        for (var skill in widget.entity.skills.forFamily(family)) {
          familyEntries.add(
            DropdownMenuEntry(
              value: _StandardSkillThrowWrapper(
                skill: skill.skill,
                implementation: skill.implementation,
              ),
              label: skill.title,
            )
          );

          for (var specialization in skill.specializations) {
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
      }
      else {
        for(var skill in Skill.values.where((Skill s) => s.family == family)) {
          if(skill.requireConcreteImplementation) continue;

          familyEntries.add(
            DropdownMenuEntry(
              value: _StandardSkillThrowWrapper(
                skill: skill,
              ),
              label: skill.title,
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

    return Column(
      spacing: 8.0,
      children: [
        DropdownMenuFormField(
          label: const Text('Attribut'),
          textStyle: theme.textTheme.bodySmall,
          expandedInsets: EdgeInsets.zero,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            isCollapsed: true,
            constraints: BoxConstraints(maxHeight: 36.0),
            contentPadding: EdgeInsets.all(12.0),
          ),
          dropdownMenuEntries: Attribute.values
              .map((Attribute a) => DropdownMenuEntry(value: a, label: a.title))
              .toList(),
          onSelected: (Attribute? a) {
            attribute = a;
            notifyBase();
          },
          validator: (Attribute? a) {
            if(a == null) return "Attribut requis";
            return null;
          },
        ),
        Row(
          spacing: 8.0,
          children: [
            Switch(
              value: useEntitySkills,
              onChanged: (bool v) {
                setState(() {
                  useEntitySkills = v;
                  selected = null;
                });
                widget.onFallbackAbilityRequiredChanged(!v);
                notifyBase();
              },
            ),
            Expanded(
              child: const Text("Utiliser les compétences de l'opposant")
            ),
          ],
        ),
        DropdownMenuFormField(
          label: Text(
            'Compétence',
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
            notifyBase();
          },
          dropdownMenuEntries: entries,
          validator: (_SkillThrowWrapper? w) {
            if(w == null) return "Compétence requise";
            return null;
          },
        ),
      ],
    );
  }
}

class _OpposingRequestTypeAbilityWidget extends StatefulWidget {
  const _OpposingRequestTypeAbilityWidget({
    required this.onBaseSet,
  });

  final void Function(DiceThrowEntityBase?) onBaseSet;

  @override
  State<_OpposingRequestTypeAbilityWidget> createState() => _OpposingRequestTypeAbilityWidgetState();
}

class _OpposingRequestTypeAbilityWidgetState extends State<_OpposingRequestTypeAbilityWidget> {
  Attribute? attribute;
  Ability? ability;

  void notifyBase() {
    if(attribute == null || ability == null) {
      widget.onBaseSet(null);
    }
    else {
      widget.onBaseSet(
        DiceThrowEntityBaseAbility(attribute: attribute!, ability: ability!)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      spacing: 8.0,
      children: [
        DropdownMenuFormField(
          label: const Text('Attribut'),
          textStyle: theme.textTheme.bodySmall,
          expandedInsets: EdgeInsets.zero,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            isCollapsed: true,
            constraints: BoxConstraints(maxHeight: 36.0),
            contentPadding: EdgeInsets.all(12.0),
          ),
          dropdownMenuEntries: Attribute.values
            .map((Attribute a) => DropdownMenuEntry(value: a, label: a.title))
            .toList(),
          onSelected: (Attribute? a) {
            attribute = a;
            notifyBase();
          },
          validator: (Attribute? a) {
            if(a == null) return "Attribut requis";
            return null;
          },
        ),
        DropdownMenuFormField(
          label: const Text('Caractéristique'),
          textStyle: theme.textTheme.bodySmall,
          expandedInsets: EdgeInsets.zero,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            isCollapsed: true,
            constraints: BoxConstraints(maxHeight: 36.0),
            contentPadding: EdgeInsets.all(12.0),
          ),
          dropdownMenuEntries: Ability.values
            .map((Ability a) => DropdownMenuEntry(value: a, label: a.title))
            .toList(),
          onSelected: (Ability? a) {
            ability = a;
            notifyBase();
          },
          validator: (Ability? a) {
            if(a == null) return "Caractéristique requise";
            return null;
          },
        ),
      ],
    );
  }
}

class _AbilityThrowMenuWidget extends StatefulWidget {
  const _AbilityThrowMenuWidget({
    required this.entities,
  });

  final List<EntityBase> entities;

  @override
  State<_AbilityThrowMenuWidget> createState() => _AbilityThrowMenuWidgetState();
}

class _AbilityThrowMenuWidgetState extends State<_AbilityThrowMenuWidget> {
  Ability? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        Expanded(
          child: DropdownMenu(
            label: Text(
              'Jet de caractéristique',
            ),
            textStyle: theme.textTheme.bodySmall,
            expandedInsets: EdgeInsets.zero,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            onSelected: (Ability? a) {
              setState(() {
                selected = a;
              });
            },
            dropdownMenuEntries: Ability.values
              .map((Ability a) => DropdownMenuEntry(value: a, label: a.title))
              .toList(),
          ),
        ),
        IconButton(
          onPressed: selected == null ? null : () async {
            var result = await showDialog<_PrepareSkillThrowResult>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => _PrepareSkillThrowDialog(
                actors: widget.entities,
              ),
            );
            if(result == null) return;
            if(!context.mounted) return;

            var base = DiceThrowEntityBaseAbility(
              attribute: result.attribute,
              ability: selected!,
            );

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
                  entities: widget.entities,
                  request: request,
                  canChangeDifficulty: true,
                )
            );
            if(bundles == null || bundles.isEmpty) return;
            if(!context.mounted) return;

            if(result.difficulty != null) {
              var evaluation = evaluateDiceThrow(bundles.first);
            }
          },
          icon: Icon(CustomIcons.d10),
        )
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