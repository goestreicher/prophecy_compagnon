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
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_enums.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/dismissible_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/dice_throw_shared_widgets.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityDiceThrowSimpleWidget extends StatefulWidget {
  const EntityDiceThrowSimpleWidget({
    super.key,
    required this.onBundleReady,
    required this.entity,
    required this.request,
    this.canChangeDifficulty = false,
    this.difficultyHints,
    this.contextModifierHints,
    this.canUseProficiency = true,
    this.canUseTendencies = true,
    this.canUseLuck = true,
  });

  final void Function(EntityThrowBundle) onBundleReady;
  final EntityBase entity;
  final DiceThrowRequest request;
  final bool canChangeDifficulty;
  final Map<String, int>? difficultyHints;
  final List<String>? contextModifierHints;
  final bool canUseProficiency;
  final bool canUseTendencies;
  final bool canUseLuck;

  @override
  State<EntityDiceThrowSimpleWidget> createState() => _EntityDiceThrowSimpleWidgetState();
}

class _EntityDiceThrowSimpleWidgetState extends State<EntityDiceThrowSimpleWidget> {
  int? proficiency;
  bool useTendencies = false;
  bool diceThrowDone = false;
  int? mainDie;
  Tendency? announcedTendency;
  Tendency? keptTendency;
  int? dragonDie;
  int? fatalityDie;
  int? humanDie;
  int? luck;
  int? criticalDie;
  bool isCriticalSuccess = false;
  Map<String, DiceThrowModifier> overrideEntityModifiers = <String, DiceThrowModifier>{};
  Set<String> appliedEntityModifiers = <String>{};
  int contextModifier = 0;
  EntityBase? selectedPeer;
  Set<String> appliedPeerModifiers = <String>{};

  static List<String> defaultContextModifierHints = [
    "-4 : Ne jamais avoir tenté l'action auparavant",
    "-3 : Oublier d'ôter ses bottes pour nager",
    "-2 : Courir en sandales, peindre à la bougie",
    "-1 : Utiliser du matériel mal entretenu",
    "0 : Action effectuée sans préparation particulière",
    "+1 : Prendre de l'élan pour sauter en selle",
    "+2 : Se faire expliquer la manœuvre par un expert juste avant",
    "+3 : Huiler un parquet pour marcher en silence",
    "+4 : Gravir une falaise avec des crampons, des pitons et de la corde de réserve",
  ];

  @override
  void initState() {
    super.initState();

    // By default, consider all entity modifiers applied
    appliedEntityModifiers.addAll(
        widget.entity.throwModifiers(widget.request)
            .map((DiceThrowModifier m) => m.id)
    );
  }

  bool hasDieResult() {
    if(!diceThrowDone) {
      return false;
    }

    if(useTendencies) {
      if(keptTendency == null) {
        return false;
      }

      if(dragonDie == null || fatalityDie == null || humanDie == null) {
        return false;
      }
    }
    else {
      return mainDie != null;
    }

    return true;
  }

  DiceThrowResult createResult() {
    var modifiers = entityModifiers()
      .where((DiceThrowModifier m) => appliedEntityModifiers.contains(m.id))
      .toList();

    if(selectedPeer != null) {
      modifiers.addAll(
        selectedPeer!.peerThrowModifiers()
          .where((DiceThrowModifier m) => appliedPeerModifiers.contains(m.id))
      );
    }

    if(contextModifier != 0) {
      modifiers.add(
        OneOffDiceThrowModifier(
          type: contextModifier < 0
            ? DiceThrowModifierType.malus
            : DiceThrowModifierType.bonus,
          family: DiceThrowModifierFamily.context,
          label: 'Modificateur de contexte',
          value: contextModifier,
          name: 'context',
        )
      );
    }

    if(widget.request.base.difficultyModifier(widget.entity) != 0) {
      if(widget.request.difficulty != null) {
        modifiers.add(
          OneOffDiceThrowModifier(
            type: DiceThrowModifierType.difficulty,
            family: DiceThrowModifierFamily.context,
            label: widget.request.base.difficultyModifierLabel(widget.entity),
            value: widget.request.base.difficultyModifier(widget.entity),
            name: 'baseDifficultyModifier',
          )
        );
      }
      else {
        modifiers.add(
          OneOffDiceThrowModifier(
            type: DiceThrowModifierType.malus,
            family: DiceThrowModifierFamily.context,
            label: widget.request.base.difficultyModifierLabel(widget.entity),
            value: -widget.request.base.difficultyModifier(widget.entity),
            name: 'baseDifficultyModifierAsMalus',
          )
        );
      }
    }

    if(isCriticalSuccess) {
      modifiers.add(
        OneOffDiceThrowModifier(
          type: DiceThrowModifierType.bonus,
          family: DiceThrowModifierFamily.criticalDiceThrow,
          label: 'Réussite critique',
          value: 5,
          name: 'success',
        )
      );
    }

    return DiceThrowResult(
      mainDie: mainDie,
      usedTendencies: useTendencies,
      announcedTendency: announcedTendency,
      keptTendency: keptTendency,
      dragonDie: dragonDie,
      fatalityDie: fatalityDie,
      humanDie: humanDie,
      proficiency: proficiency,
      luck: luck,
      criticalDie: criticalDie,
      modifiers: modifiers,
    );
  }

  bool mustRollCritical() {
    if(!hasDieResult()) return false;
    var die = createResult().dieResult();
    return die == 1 || die == 10;
  }

  List<DiceThrowModifier> entityModifiers() {
    var ret = <DiceThrowModifier>[];

    for(var m in widget.entity.throwModifiers(widget.request)) {
      if(overrideEntityModifiers.containsKey(m.id)) {
        ret.add(overrideEntityModifiers[m.id]!);
      }
      else {
        ret.add(m);
      }
    }

    return ret;
  }

  EntityThrowBundle createBundle() => EntityThrowBundle(
    entity: widget.entity,
    request: widget.request,
    result: createResult(),
  );

  void notifyBundle() {
    if(!hasDieResult() || (mustRollCritical() && criticalDie == null)) return;
    widget.onBundleReady(createBundle());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var baseScoreWidgets = <Widget>[];
    if(widget.request.base.baseLabel(widget.entity).isNotEmpty) {
      baseScoreWidgets.add(
        Text(
          '${widget.request.base.baseLabel(widget.entity)} : ${widget.request.base.baseValue(widget.entity)}',
        )
      );
    }
    if(widget.request.base.componentLabel(widget.entity).isNotEmpty) {
      baseScoreWidgets.add(
        Text(
          '${widget.request.base.componentLabel(widget.entity)} : ${widget.request.base.componentValue(widget.entity)}',
        )
      );
    }

    var entityEffectRows = <Widget>[];
    for(var e in widget.entity.effects.where((EntityEffect e) => e.trigger == EntityEffectTrigger.diceThrow)) {
      entityEffectRows.add(
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                DiceThrowEvaluation? activationDiceThrowEvaluation;

                if (e.activationDiceThrowRequest != null) {
                  var resultBundles = await showDialog<List<EntityThrowBundle>>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) =>
                      EntityDiceThrowDialog(
                        entities: [widget.entity],
                        request: e.activationDiceThrowRequest!,
                      )
                  );
                  if(resultBundles == null || resultBundles.isEmpty) return;
                  if(!context.mounted) return;

                  activationDiceThrowEvaluation = evaluateDiceThrow(resultBundles.first);
                  if(!e.canApply(target: widget.entity, activationDiceThrowEvaluation: activationDiceThrowEvaluation)) {
                    // TODO: display a message?
                    return;
                  }
                }

                setState(() {
                  if(e.active) {
                    e.unapply(target: widget.entity);
                  }
                  else {
                    e.apply(target: widget.entity);
                  }
                });
                notifyBundle();
              },
              child: Row(
                children: [
                  Icon(
                    e.active
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  ),
                  Text(e.name),
                ],
              ),
            ),
          ],
        ),
      );
    }

    var entityDifficultyModifierRows = <Widget>[];
    var entityThrowModifierRows = <Widget>[];
    for(var m in widget.entity.throwModifiers(widget.request)) {
      Widget label = Text.rich(
        TextSpan(
          children: [
            TextSpan(text: m.label),
            if(m.valueOverrideDiceThrowRequest != null)
              TextSpan(text: ' '),
            if(m.valueOverrideDiceThrowRequest != null)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: IconButton(
                  onPressed: !appliedEntityModifiers.contains(m.id) || overrideEntityModifiers.containsKey(m.id) ? null : () async {
                    var resultBundles = await showDialog<List<EntityThrowBundle>>(
                      context: context,
                      builder: (BuildContext context) =>
                        EntityDiceThrowDialog(
                          entities: [widget.entity],
                          request: m.valueOverrideDiceThrowRequest!,
                        )
                    );
                    if(resultBundles == null || resultBundles.isEmpty) return;
                    if(!context.mounted) return;

                    var evaluation = evaluateDiceThrow(resultBundles.first);
                    var overrideMod = m.buildOverrideModifier(evaluation: evaluation);

                    if(overrideMod != null) {
                      setState(() {
                        overrideEntityModifiers[m.id] = overrideMod;
                      });
                    }
                  },
                  icon: Icon(Icons.settings),
                  iconSize: 18.0,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4.0),
                )
              ),
          ]
        )
      );

      if(!m.alwaysApply) {
        label = GestureDetector(
          onTap: () {
            setState(() {
              if(appliedEntityModifiers.contains(m.id)) {
                appliedEntityModifiers.remove(m.id);
              }
              else {
                appliedEntityModifiers.add(m.id);
              }
            });
            notifyBundle();
          },
          child: Row(
            children: [
              Icon(
                appliedEntityModifiers.contains(m.id)
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              label,
            ],
          ),
        );
      }

      var row = Row(
        children: [
          label,
          Spacer(),
          DiceThrowValuePill(value: overrideEntityModifiers[m.id]?.value ?? m.value),
        ],
      );

      switch(m.type) {
        case DiceThrowModifierType.bonus:
        case DiceThrowModifierType.malus:
          entityThrowModifierRows.add(row);
        case DiceThrowModifierType.difficulty:
          entityDifficultyModifierRows.add(row);
      }
    }

    var peerThrowModifierRows = <Widget>[];
    for(var m in (selectedPeer?.peerThrowModifiers() ?? <DiceThrowModifier>[])) {
      Widget label = GestureDetector(
        onTap: () {
          setState(() {
            if(appliedPeerModifiers.contains(m.id)) {
              appliedPeerModifiers.remove(m.id);
            }
            else {
              appliedPeerModifiers.add(m.id);
            }
          });
          notifyBundle();
        },
        child: Row(
          children: [
            Icon(
              appliedPeerModifiers.contains(m.id)
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            ),
            Text(
              m.label,
            ),
          ],
        ),
      );

      var row = Row(
        children: [
          label,
          Spacer(),
          DiceThrowValuePill(value: overrideEntityModifiers[m.id]?.value ?? m.value),
        ],
      );

      peerThrowModifierRows.add(row);
    }

    if(widget.request.base.difficultyModifier(widget.entity) != 0) {
      entityDifficultyModifierRows.add(
        Row(
          children: [
            Text(widget.request.base.difficultyModifierLabel(widget.entity)),
            Spacer(),
            DiceThrowValuePill(value: widget.request.base.difficultyModifier(widget.entity)),
          ]
        )
      );
    }

    if(isCriticalSuccess) {
      entityThrowModifierRows.add(
        Row(
          children: [
            Text('Réussite critique'),
            Spacer(),
            DiceThrowValuePill(value: 5),
          ]
        )
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              spacing: 12.0,
              children: [
                if(baseScoreWidgets.isNotEmpty)
                  DiceThrowRow(
                    title: Text(
                      'Score de base',
                      style: theme.textTheme.bodySmall,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: baseScoreWidgets,
                      ),
                    ),
                    child: DiceThrowValuePill(
                      value: widget.request.base.value(widget.entity),
                    ),
                  ),
                if(entityEffectRows.isNotEmpty)
                  WidgetGroupContainer(
                    title: Text(
                      'Effets',
                      style: theme.textTheme.bodySmall,
                    ),
                    titleBackgroundColor: theme.colorScheme.surfaceContainerHigh,
                    child: Column(
                      spacing: 8.0,
                      children: [
                        ...entityEffectRows,
                      ],
                    ),
                  ),
                if(entityDifficultyModifierRows.isNotEmpty)
                  WidgetGroupContainer(
                    title: Text(
                      'Modificateurs de difficulté',
                      style: theme.textTheme.bodySmall,
                    ),
                    titleBackgroundColor: theme.colorScheme.surfaceContainerHigh,
                    child: Column(
                      spacing: 8.0,
                      children: [
                        ...entityDifficultyModifierRows,
                      ],
                    )
                  ),
                WidgetGroupContainer(
                  title: Text(
                    'Modificateurs de jet',
                    style: theme.textTheme.bodySmall,
                  ),
                  titleBackgroundColor: theme.colorScheme.surfaceContainerHigh,
                  child: Column(
                    spacing: 8.0,
                    children: [
                      ...entityThrowModifierRows,
                      Row(
                        spacing: 8.0,
                        children: [
                          Text('Modificateur de contexte'),
                          IconButton(
                            style: IconButton.styleFrom(
                              iconSize: 16.0,
                            ),
                            padding: const EdgeInsets.all(4.0),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.info_outlined),
                            onPressed: () {
                              Navigator.of(context).push(
                                DismissibleDialog<void>(
                                  title: 'Modificateurs',
                                  content: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 400,
                                      maxWidth: 400,
                                      maxHeight: 400,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        '\u2022 '
                                        '${(widget.contextModifierHints ?? defaultContextModifierHints).join("\n\u2022 ")}',
                                      ),
                                    )
                                  )
                                )
                              );
                            },
                          ),
                          Spacer(),
                          SizedBox(
                            width: 70.0,
                            child: NumIntInputWidget(
                              initialValue: 0,
                              minValue: -30,
                              maxValue: 30,
                              onChanged: (int v) {
                                setState(() {
                                  contextModifier = v;
                                });
                                notifyBundle();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                WidgetGroupContainer(
                  title: Text(
                    "Modificateurs d'un autre personnage",
                    style: theme.textTheme.bodySmall,
                  ),
                  titleBackgroundColor: theme.colorScheme.surfaceContainerHigh,
                  child: Column(
                    spacing: 8.0,
                    children: [
                      DropdownMenu(
                        textStyle: theme.textTheme.bodySmall,
                        expandedInsets: EdgeInsets.zero,
                        inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(),
                          isCollapsed: true,
                          constraints: BoxConstraints(maxHeight: 36.0),
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        dropdownMenuEntries: (GameSession.instance?.entities() ?? <EntityBase>[])
                          .where((EntityBase e) => e.id != widget.entity.id)
                          .map((EntityBase e) => DropdownMenuEntry(value: e, label: e.name))
                          .toList(),
                        onSelected: (EntityBase? e) {
                          setState(() {
                            appliedPeerModifiers.clear();
                            selectedPeer = e;
                          });
                        },
                      ),
                      ...peerThrowModifierRows,
                    ],
                  )
                ),
                if(widget.entity is HumanCharacter && widget.canUseProficiency)
                  DiceThrowRow(
                    label: Text('Maîtrise (max ${(widget.entity as HumanCharacter).availableProficiency})'),
                    child: SizedBox(
                      width: 70,
                      child: NumIntInputWidget(
                        enabled: !diceThrowDone,
                        initialValue: 0,
                        minValue: 0,
                        maxValue: (widget.entity as HumanCharacter).availableProficiency,
                        onChanged: (int v) {
                          setState(() {
                            proficiency = v;
                          });
                        },
                      ),
                    ),
                  ),
                if(widget.entity is HumanCharacter && widget.canUseTendencies)
                  Row(
                    children: [
                      Switch(
                        value: useTendencies,
                        onChanged: diceThrowDone ? null : (bool v) async {
                          if(v) {
                            var hc = widget.entity as HumanCharacter;
                            var highestValue = [
                                hc.tendencies.dragon.value,
                                hc.tendencies.fatality.value,
                                hc.tendencies.human.value
                              ]
                              .reduce(max);

                            var announcedCandidates = <Tendency>[];
                            for(var t in Tendency.values) {
                              if(hc.tendencies[t].value == highestValue) {
                                announcedCandidates.add(t);
                              }
                            }

                            Tendency announced;
                            if(announcedCandidates.length == 1) {
                              announced = announcedCandidates[0];
                            }
                            else {
                              var r = await showDialog<Tendency>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: Text(
                                        "Sélectionner la tendance annoncée"
                                    ),
                                    children: [
                                      for(var t in announcedCandidates)
                                        SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.of(context, rootNavigator: true).pop(t);
                                          },
                                          child: Text(
                                            t.title,
                                          ),
                                        ),
                                    ],
                                  );
                                }
                              );
                              if(!context.mounted) return;
                              if(r == null) return;
                              announced = r;
                            }

                            setState(() {
                              announcedTendency = announced;
                            });
                          }

                          setState(() {
                            useTendencies = v;
                          });
                        },
                      ),
                      Text(
                        'Utiliser les Tendances',
                      ),
                    ],
                  ),
                if(!useTendencies)
                  DiceThrowRow(
                    label: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Dé '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: IconButton(
                              onPressed: diceThrowDone ? null : () {
                                setState(() {
                                  mainDie = Random().nextInt(10) + 1;
                                  diceThrowDone = true;
                                });
                                if(!mustRollCritical()) {
                                  notifyBundle();
                                }
                              },
                              icon: Icon(CustomIcons.d10),
                              iconSize: 18.0,
                              tooltip: 'Lancer',
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: DiceThrowTextPill(
                      text: mainDie?.toString(),
                    ),
                  ),
                if(useTendencies)
                  TendencyThrowWidget(
                    diceThrowDone: diceThrowDone,
                    onDieChanged: (Tendency t, int v) {
                      setState(() {
                        diceThrowDone = true;
                        switch(t) {
                          case Tendency.dragon:
                            dragonDie = v;
                          case Tendency.fatality:
                            fatalityDie = v;
                          case Tendency.human:
                            humanDie = v;
                        }
                      });
                    },
                    announcedTendency: announcedTendency!,
                    keptTendency: keptTendency,
                    onDieKept: (Tendency t) {
                      setState(() {
                        keptTendency = t;
                      });
                      if(!mustRollCritical()) {
                        notifyBundle();
                      }
                    },
                    dragonDie: dragonDie,
                    fatalityDie: fatalityDie,
                    humanDie: humanDie,
                  ),
                if(mustRollCritical())
                  DiceThrowRow(
                    label: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Dé de Critique '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: IconButton(
                              onPressed: criticalDie != null ? null : () {
                                setState(() {
                                  criticalDie = Random().nextInt(10) + 1;
                                  var r = createResult();
                                  if(r.criticalType(widget.request.base.componentValue(widget.entity)) == DiceThrowResultType.criticalSuccess) {
                                    isCriticalSuccess = true;
                                  }
                                });
                                notifyBundle();
                              },
                              icon: Icon(CustomIcons.d10),
                              iconSize: 18.0,
                              tooltip: 'Lancer',
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: DiceThrowTextPill(
                      text: criticalDie?.toString(),
                    ),
                  ),
                if(widget.entity is HumanCharacter && widget.canUseLuck)
                  DiceThrowRow(
                    label: Text('Chance (max ${(widget.entity as HumanCharacter).availableLuck})'),
                    child: SizedBox(
                      width: 70,
                      child: NumIntInputWidget(
                        enabled: diceThrowDone,
                        initialValue: 0,
                        minValue: 0,
                        maxValue: (widget.entity as HumanCharacter).availableLuck,
                        onChanged: (int v) {
                          setState(() {
                            luck = v;
                          });
                          notifyBundle();
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}