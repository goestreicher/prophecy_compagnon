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
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_type.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/dismissible_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/entity/pill_widget.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityDiceThrowDialog extends StatefulWidget {
  const EntityDiceThrowDialog({
    super.key,
    required this.entity,
    required this.request,
    this.canChangeDifficulty = false,
    this.difficultyHints,
    this.contextModifierHints,
  });

  final EntityBase entity;
  final DiceThrowRequest request;
  final bool canChangeDifficulty;
  final Map<String, int>? difficultyHints;
  final List<String>? contextModifierHints;

  @override
  State<EntityDiceThrowDialog> createState() => _EntityDiceThrowDialogState();
}

class _EntityDiceThrowDialogState extends State<EntityDiceThrowDialog> {
  EntityThrowBundle? bundle;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget throwWidget;
    switch(widget.request.type) {
      case DiceThrowRequestType.threshold:
        throwWidget = _EntityThresholdDiceThrowWidget(
          entity: widget.entity,
          request: widget.request,
          onBundleReady: (EntityThrowBundle b) {
            setState(() {
              bundle = b;
            });
          },
        );
      case DiceThrowRequestType.simple:
      case DiceThrowRequestType.oppositionDirect:
      case DiceThrowRequestType.oppositionNR:
        throwWidget = _EntitySimpleDiceThrowWidget(
          entity: widget.entity,
          request: widget.request,
          canChangeDifficulty: widget.canChangeDifficulty,
          difficultyHints: widget.difficultyHints,
          contextModifierHints: widget.contextModifierHints,
          onBundleReady: (EntityThrowBundle b) {
            setState(() {
              bundle = b;
            });
          },
        );
    }

    return AlertDialog(
      title: Row(
        spacing: 8.0,
        children: [
          EntityPillWidget(
            entity: widget.entity,
            width: 40,
            height: 40,
          ),
          Expanded(
            child: Text(
              'Jet de ${widget.request.base.label}',
            ),
          )
        ],
      ),
      content: SizedBox(
        width: 350,
        child: throwWidget,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: bundle == null ? null : () {
            Navigator.of(context, rootNavigator: true).pop(bundle);
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

class _EntityThresholdDiceThrowWidget extends StatefulWidget {
  const _EntityThresholdDiceThrowWidget({
    required this.onBundleReady,
    required this.entity,
    required this.request,
  });

  final void Function(EntityThrowBundle) onBundleReady;
  final EntityBase entity;
  final DiceThrowRequest request;

  @override
  State<_EntityThresholdDiceThrowWidget> createState() => _EntityThresholdDiceThrowWidgetState();
}

class _EntityThresholdDiceThrowWidgetState extends State<_EntityThresholdDiceThrowWidget> {
  int? result;

  DiceThrowResult createResult() => DiceThrowResult(
    mainDie: result,
  );

  EntityThrowBundle createBundle() => EntityThrowBundle(
    entity: widget.entity,
    request: DiceThrowRequest(
      type: widget.request.type,
      context: widget.request.context,
      base: widget.request.base,
      allowTendencies: widget.request.allowTendencies,
    ),
    result: createResult(),
  );

  void notifyBundle() {
    if(result == null) return;
    widget.onBundleReady(createBundle());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var totalColor = Colors.indigo;
    String? totalText;
    if(result != null) {
      var bundle = createBundle();
      var eval = evaluateDiceThrow(bundle);

      if(eval.resultType == DiceThrowResultType.fail) {
        totalColor = Colors.red;
        totalText = 'Échec';
      }
      else {
        totalColor = Colors.green;
        totalText = 'Réussite';
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DiceThrowRow(
          label: Text(widget.request.base.label),
          child: _ValuePill(value: widget.request.base.value(widget.entity)),
        ),
        _DiceThrowRow(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Dé '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: IconButton(
                    onPressed: result != null ? null : () {
                      setState(() {
                        result = Random().nextInt(10) + 1;
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
          child: _TextPill(
            text: result?.toString(),
          ),
        ),
        Row(
          children: [
            Text(
              'Résultat',
              style: theme.textTheme.headlineSmall,
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                color: totalColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                child: Text(
                  totalText ?? '?',
                  style: theme.textTheme.headlineSmall!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _EntitySimpleDiceThrowWidget extends StatefulWidget {
  const _EntitySimpleDiceThrowWidget({
    required this.onBundleReady,
    required this.entity,
    required this.request,
    this.canChangeDifficulty = false,
    this.difficultyHints,
    this.contextModifierHints,
  });

  final void Function(EntityThrowBundle) onBundleReady;
  final EntityBase entity;
  final DiceThrowRequest request;
  final bool canChangeDifficulty;
  final Map<String, int>? difficultyHints;
  final List<String>? contextModifierHints;

  @override
  State<_EntitySimpleDiceThrowWidget> createState() => _EntitySimpleDiceThrowWidgetState();
}

class _EntitySimpleDiceThrowWidgetState extends State<_EntitySimpleDiceThrowWidget> {
  int? difficulty;
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
  Map<String, DiceThrowModifier> overrideModifiers = <String, DiceThrowModifier>{};
  Set<String> appliedModifiers = <String>{};
  int contextModifier = 0;
  int difficultyModifiersTotal = 0;

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

    difficulty = widget.request.difficulty;

    // By default, consider all entity modifiers applied
    appliedModifiers.addAll(
        widget.entity.throwModifiers(widget.request)
            .map((DiceThrowModifier m) => m.id)
    );

    updateModifiersTotal();
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
        .where((DiceThrowModifier m) => appliedModifiers.contains(m.id))
        .toList();

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
      if(overrideModifiers.containsKey(m.id)) {
        ret.add(overrideModifiers[m.id]!);
      }
      else {
        ret.add(m);
      }
    }

    if(isCriticalSuccess) {
      ret.add(
        OneOffDiceThrowModifier(
          type: DiceThrowModifierType.bonus,
          family: DiceThrowModifierFamily.criticalDiceThrow,
          label: 'Réussite critique',
          value: 5,
          name: 'success',
        )
      );
    }

    return ret;
  }

  void updateModifiersTotal() {
    var difficultyTotal = 0;

    for(var m in entityModifiers()) {
      if(appliedModifiers.contains(m.id)) {
        switch(m.type) {
          case DiceThrowModifierType.malus:
          case DiceThrowModifierType.bonus:
            break;
          case DiceThrowModifierType.difficulty:
            difficultyTotal += overrideModifiers[m.id]?.value ?? m.value;
        }
      }
    }

    difficultyTotal += widget.request.base.difficultyModifier(widget.entity);

    difficultyModifiersTotal = difficultyTotal;
  }

  EntityThrowBundle createBundle() => EntityThrowBundle(
    entity: widget.entity,
    request: DiceThrowRequest(
      type: widget.request.type,
      context: widget.request.context,
      difficulty: difficulty,
      base: widget.request.base,
      allowTendencies: widget.request.allowTendencies,
    ),
    result: createResult(),
  );

  void notifyBundle() {
    if(!hasDieResult() || (mustRollCritical() && criticalDie == null)) return;
    widget.onBundleReady(createBundle());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget? difficultyWidget;
    if(widget.canChangeDifficulty) {
      difficultyWidget = Column(
        spacing: 8.0,
        children: [
          Row(
            spacing: 8.0,
            children: [
              Text(
                'Difficulté',
              ),
              Spacer(),
              SizedBox(
                width: 70,
                child: NumIntInputWidget(
                  initialValue: difficulty ?? 0,
                  minValue: 0,
                  maxValue: 99,
                  onChanged: (int v) {
                    setState(() {
                      difficulty = v;
                    });
                    notifyBundle();
                  },
                ),
              ),
            ],
          ),
          if(widget.difficultyHints?.isNotEmpty ?? false)
            Row(
              spacing: 8.0,
              children: [
                Text(
                  'Propositions de difficulté'
                ),
                Expanded(
                  child: DropdownMenu(
                    textStyle: theme.textTheme.bodySmall,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      constraints: BoxConstraints(maxHeight: 36.0),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    onSelected: (int? v) {
                      if(v == null) return;

                      setState(() {
                        difficulty = v;
                      });
                      notifyBundle();
                    },
                    dropdownMenuEntries: widget.difficultyHints!.entries
                      .map(
                        (MapEntry<String, int> e) => DropdownMenuEntry(
                          value: e.value, label: '${e.value}: ${e.key}',
                        )
                      )
                      .toList(),
                  ),
                )
              ],
            )
        ],
      );
    }

    var entityModifierRows = <Widget>[];
    for(var m in entityModifiers()) {
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
                  onPressed: !appliedModifiers.contains(m.id) || overrideModifiers.containsKey(m.id) ? null : () async {
                    var bundle = await showDialog<EntityThrowBundle>(
                      context: context,
                      builder: (BuildContext context) =>
                        EntityDiceThrowDialog(
                          entity: widget.entity,
                          request: m.valueOverrideDiceThrowRequest!,
                        )
                    );
                    if(bundle == null) return;
                    if(!context.mounted) return;

                    var evaluation = evaluateDiceThrow(bundle);
                    var overrideMod = m.buildOverrideModifier(evaluation: evaluation);

                    if(overrideMod != null) {
                      setState(() {
                        overrideModifiers[m.id] = overrideMod;
                        updateModifiersTotal();
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
              if(appliedModifiers.contains(m.id)) {
                appliedModifiers.remove(m.id);
              }
              else {
                appliedModifiers.add(m.id);
              }
              updateModifiersTotal();
            });
            notifyBundle();
          },
          child: Row(
            children: [
              Icon(
                appliedModifiers.contains(m.id)
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              ),
              label,
            ],
          ),
        );
      }

      entityModifierRows.add(
        Row(
          children: [
            label,
            Spacer(),
            _ValuePill(value: overrideModifiers[m.id]?.value ?? m.value),
          ],
        )
      );
    }

    String? totalText;
    var totalColor = Colors.indigo;
    if(hasDieResult()) {
      var dieResult = createResult();

      if(mustRollCritical()) {
        if(
            criticalDie != null
            && dieResult.criticalType(
                widget.request.base.componentValue(widget.entity)
              ) == DiceThrowResultType.criticalFail
        ) {
          totalText = 'Échec critique';
          totalColor = Colors.red;
        }
      }

      if(totalText == null) {
        var total =
            widget.request.base.value(widget.entity)
            + dieResult.total();
        totalText = total.toString();

        if(difficulty != null) {
          if(total >= (difficulty! + difficultyModifiersTotal)) {
            totalColor = Colors.green;
          }
          else {
            totalColor = Colors.red;
          }
        }
      }
    }

    var totalWidget = Container(
      decoration: BoxDecoration(
        color: totalColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Text(
          totalText ?? '?',
          style: theme.textTheme.headlineSmall!
              .copyWith(color: Colors.white),
        ),
      ),
    );

    Widget? difficultyTotalWidget;
    if(difficulty != null) {
      difficultyTotalWidget = Container(
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          child: Text(
            (difficulty! + difficultyModifiersTotal).toString(),
            style: theme.textTheme.headlineSmall!
                .copyWith(color: Colors.white),
          ),
        ),
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
                ?difficultyWidget,
                _DiceThrowRow(
                  title: Text(
                    'Score de base',
                    style: theme.textTheme.bodySmall,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.request.base.baseLabel(widget.entity)} : ${widget.request.base.baseValue(widget.entity)}',
                        ),
                        Text(
                          '${widget.request.base.componentLabel(widget.entity)} : ${widget.request.base.componentValue(widget.entity)}',
                        )
                      ],
                    ),
                  ),
                  child: _ValuePill(
                    value: widget.request.base.value(widget.entity),
                  ),
                ),
                WidgetGroupContainer(
                  title: Text(
                    'Modificateurs',
                    style: theme.textTheme.bodySmall,
                  ),
                  titleBackgroundColor: theme.colorScheme.surfaceContainerHigh,
                  child: Column(
                    spacing: 8.0,
                    children: [
                      ...entityModifierRows,
                      if(widget.request.base.difficultyModifier(widget.entity) != 0)
                        Row(
                          spacing: 8.0,
                          children: [
                            Text('${widget.request.base.difficultyModifierLabel(widget.entity)} (Diff.)'),
                            Spacer(),
                            _ValuePill(
                              value: widget.request.base.difficultyModifier(widget.entity),
                            ),
                          ],
                        ),
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
                if(widget.entity is HumanCharacter)
                  _DiceThrowRow(
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
                if(widget.entity is HumanCharacter)
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
                  _DiceThrowRow(
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
                    child: _TextPill(
                      text: mainDie?.toString(),
                    ),
                  ),
                if(useTendencies)
                  _TendencyThrowWidget(
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
                  _DiceThrowRow(
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
                    child: _TextPill(
                      text: criticalDie?.toString(),
                    ),
                  ),
                if(widget.entity is HumanCharacter)
                  _DiceThrowRow(
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
        Row(
          children: [
            Text(
              'Total',
              style: theme.textTheme.headlineSmall,
            ),
            Spacer(),
            totalWidget,
            if(difficultyTotalWidget != null)
              Text(
                ' vs. ',
                style: theme.textTheme.headlineSmall,
              ),
            ?difficultyTotalWidget,
          ],
        ),
      ],
    );
  }
}

class _DiceThrowRow extends StatelessWidget {
  const _DiceThrowRow({
    this.title,
    required this.label,
    required this.child,
  });

  final Widget? title;
  final Widget label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: title,
      titleBackgroundColor: theme.colorScheme.surfaceContainerHigh,
      child: Row(
        spacing: 8.0,
        children: [
          label,
          Spacer(),
          child,
        ],
      )
    );
  }
}

class _TextPill extends StatelessWidget {
  const _TextPill({
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          child: Text(
            text ?? '?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _ValuePill extends StatelessWidget {
  const _ValuePill({
    required this.value,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    // TODO: manage text color if the value is positive or negative
    return _TextPill(
      text: value.toString(),
    );
  }
}

class _TendencyThrowWidget extends StatefulWidget {
  const _TendencyThrowWidget({
    this.diceThrowDone = false,
    required this.onDieChanged,
    required this.announcedTendency,
    this.keptTendency,
    required this.onDieKept,
    this.dragonDie,
    this.fatalityDie,
    this.humanDie,
  });

  final bool diceThrowDone;
  final void Function(Tendency, int) onDieChanged;
  final Tendency announcedTendency;
  final Tendency? keptTendency;
  final void Function(Tendency) onDieKept;
  final int? dragonDie;
  final int? fatalityDie;
  final int? humanDie;

  @override
  State<_TendencyThrowWidget> createState() => _TendencyThrowWidgetState();
}

class _TendencyThrowWidgetState extends State<_TendencyThrowWidget> {
  int? dragon;
  int? fatality;
  int? human;
  bool kept = false;

  @override
  void initState() {
    super.initState();

    dragon = widget.dragonDie;
    fatality = widget.fatalityDie;
    human = widget.humanDie;
  }

  bool canSelectKeptDie() =>
      !kept && dragon != null && fatality != null && human != null;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        spacing: 8.0,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Lancer tous les dés '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: IconButton(
                    onPressed: widget.diceThrowDone ? null : () {
                      setState(() {
                        dragon = Random().nextInt(10) + 1;
                        fatality = Random().nextInt(10) + 1;
                        human = Random().nextInt(10) + 1;
                      });

                      widget.onDieChanged(Tendency.dragon, dragon!);
                      widget.onDieChanged(Tendency.fatality, fatality!);
                      widget.onDieChanged(Tendency.human, human!);
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
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: 'Dé du Dragon',
                announced: widget.announcedTendency == Tendency.dragon,
                kept: widget.keptTendency == Tendency.dragon,
              ),
              Spacer(),
              _TextPill(
                text: dragon?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.dragon);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: 'Dé de la Fatalité',
                announced: widget.announcedTendency == Tendency.fatality,
                kept: widget.keptTendency == Tendency.fatality,
              ),
              Spacer(),
              _TextPill(
                text: fatality?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.fatality);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              _TendencyDieLabel(
                label: "Dé de l'Homme",
                announced: widget.announcedTendency == Tendency.human,
                kept: widget.keptTendency == Tendency.human,
              ),
              Spacer(),
              _TextPill(
                text: human?.toString(),
              ),
              if(!kept)
                Tooltip(
                  message: 'Conserver ce dé',
                  child: ElevatedButton(
                    onPressed: !canSelectKeptDie() ? null : () {
                      setState(() {
                        kept = true;
                      });
                      widget.onDieKept(Tendency.human);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
            ],
          ),
        ],
      )
    );
  }
}

class _TendencyDieLabel extends StatelessWidget {
  const _TendencyDieLabel({
    required this.label,
    required this.announced,
    required this.kept,
  });

  final String label;
  final bool announced;
  final bool kept;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      children: [
        Text('$label '),
        if(announced)
          Tooltip(
            message: 'Annoncé',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  'A',
                  style: theme.textTheme.bodySmall!
                      .copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        if(kept)
          Tooltip(
            message: 'Conservé',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  'C',
                  style: theme.textTheme.bodySmall!
                      .copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
      ]
    );
  }
}