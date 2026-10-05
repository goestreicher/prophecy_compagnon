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
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/entity/pill_widget.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/dice_throw_shared_widgets.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_simple_widget.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_threshold_widget.dart';

const _singleThrowColumnWidth = 350.0;

class EntityDiceThrowDialog extends StatefulWidget {
  const EntityDiceThrowDialog({
    super.key,
    required this.entities,
    required this.request,
    this.canChangeDifficulty = false,
    this.difficultyHints,
    this.contextModifierHints,
  });

  final List<EntityBase> entities;
  final DiceThrowRequest request;
  final bool canChangeDifficulty;
  final Map<String, int>? difficultyHints;
  final List<String>? contextModifierHints;

  @override
  State<EntityDiceThrowDialog> createState() => _EntityDiceThrowDialogState();
}

class _EntityDiceThrowDialogState extends State<EntityDiceThrowDialog> {
  Map<String, EntityThrowBundle?> bundles = <String, EntityThrowBundle?>{};
  int? difficulty;
  late DiceThrowRequest localRequest;

  @override
  void initState() {
    super.initState();

    for(var entity in widget.entities) {
      bundles[entity.id] = null;
    }

    difficulty = widget.request.difficulty;
    buildLocalRequest();
  }

  void buildLocalRequest() {
    localRequest = DiceThrowRequest(
      type: widget.request.type,
      context: widget.request.context,
      difficulty: difficulty,
      base: widget.request.base,
      allowTendencies: widget.request.allowTendencies,
    );
  }

  void rebuildBundles() {
    for(var id in bundles.keys) {
      if(bundles[id] != null) {
        bundles[id] = EntityThrowBundle(
          entity: bundles[id]!.entity,
          request: localRequest,
          result: bundles[id]!.result,
        );
      }
    }
  }

  void disableDiceThrowEffects() {
    for(var entity in widget.entities) {
      var effects = entity.effects
          .where(
              (EntityEffect e) =>
                  e.trigger == EntityEffectTrigger.diceThrow
                  && e.active
          );

      for(var effect in effects) {
        effect.unapply(target: entity);
      }
    }
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
                      buildLocalRequest();
                      rebuildBundles();
                    });
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
                        buildLocalRequest();
                        rebuildBundles();
                      });
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

    var throwWidgets = <Widget>[];
    Widget? resultWidget;
    switch(localRequest.type) {
      case DiceThrowRequestType.threshold:
        for(var entity in widget.entities) {
          throwWidgets.add(
            SizedBox(
              width: _singleThrowColumnWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.0,
                children: [
                  EntityDiceThrowThresholdWidget(
                    entity: entity,
                    request: localRequest,
                    onBundleReady: (EntityThrowBundle b) {
                      setState(() {
                        bundles[entity.id] = b;
                      });
                    },
                  ),
                  DiceThrowResultStatusWidget(
                    bundle: bundles[entity.id],
                  ),
                ],
              ),
            )
          );
        }
      case DiceThrowRequestType.simple:
        for(var entity in widget.entities) {
          throwWidgets.add(
            SizedBox(
              width: _singleThrowColumnWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.0,
                children: [
                  EntityDiceThrowSimpleWidget(
                    entity: entity,
                    request: localRequest,
                    canChangeDifficulty: widget.canChangeDifficulty,
                    difficultyHints: widget.difficultyHints,
                    contextModifierHints: widget.contextModifierHints,
                    onBundleReady: (EntityThrowBundle b) {
                      setState(() {
                        bundles[entity.id] = b;
                      });
                    },
                  ),
                  DiceThrowResultSimpleWidget(
                    bundle: bundles[entity.id],
                  )
                ],
              ),
            )
          );
        }
      case DiceThrowRequestType.oppositionDirect:
      case DiceThrowRequestType.oppositionNR:
        if(widget.entities.length != 2) {
          throw(ArgumentError("Seulement deux personnages autorisés pour un jet d'opposition"));
        }

        throwWidgets.add(
          SizedBox(
            width: _singleThrowColumnWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.0,
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    EntityPillWidget(
                      entity: widget.entities[0],
                      width: 40.0,
                      height: 40.0
                    ),
                    Text(
                      widget.entities[0].name,
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                EntityDiceThrowSimpleWidget(
                  entity: widget.entities[0],
                  request: localRequest,
                  canChangeDifficulty: widget.canChangeDifficulty,
                  difficultyHints: widget.difficultyHints,
                  contextModifierHints: widget.contextModifierHints,
                  onBundleReady: (EntityThrowBundle b) {
                    setState(() {
                      bundles[widget.entities[0].id] = b;
                    });
                  },
                ),
              ],
            ),
          )
        );

        throwWidgets.add(
          SizedBox(
            width: _singleThrowColumnWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.0,
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    EntityPillWidget(
                      entity: widget.entities[1],
                      width: 40.0,
                      height: 40.0
                    ),
                    Text(
                      widget.entities[1].name,
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                EntityDiceThrowSimpleWidget(
                  entity: widget.entities[1],
                  request: localRequest,
                  canChangeDifficulty: widget.canChangeDifficulty,
                  difficultyHints: widget.difficultyHints,
                  contextModifierHints: widget.contextModifierHints,
                  onBundleReady: (EntityThrowBundle b) {
                    setState(() {
                      bundles[widget.entities[1].id] = b;
                    });
                  },
                ),
              ],
            ),
          )
        );

        resultWidget = DiceThrowResultOppositionWidget(
          actorBundle: bundles[widget.entities[0].id],
          opposingBundle: bundles[widget.entities[1].id],
        );
    }

    return AlertDialog(
      title: Text(
        'Jet de ${widget.request.base.label}',
      ),
      content: SizedBox(
        width: _singleThrowColumnWidth * throwWidgets.length + 12 * (throwWidgets.length - 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
          children: [
            ?difficultyWidget,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 12.0,
                children: throwWidgets,
              ),
            ),
            ?resultWidget,
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            disableDiceThrowEffects();
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: bundles.values.any((EntityThrowBundle? b) => b == null)
            ? null
            : () {
                disableDiceThrowEffects();
                Navigator.of(context, rootNavigator: true).pop(
                  bundles.values
                    .map((EntityThrowBundle? b) => b!)
                    .toList()
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