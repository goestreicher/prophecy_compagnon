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
import 'package:prophecy_compagnon_mj/ui/session/character/menus/prepare_opposition_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';

class PrepareSkillThrowResult {
  const PrepareSkillThrowResult({
    required this.attribute,
    this.difficulty,
    required this.requestType,
    this.opposing,
    this.opposingDifficulty,
    this.opposingBase,
    this.fallbackAbility,
  });

  final Attribute attribute;
  final int? difficulty;
  final DiceThrowRequestType requestType;
  final EntityBase? opposing;
  final int? opposingDifficulty;
  final DiceThrowEntityBase? opposingBase;
  final Ability? fallbackAbility;

  bool get isOpposition =>
      requestType == DiceThrowRequestType.oppositionNR
      || requestType == DiceThrowRequestType.oppositionDirect;
}

class PrepareSkillThrowDialog extends StatefulWidget {
  const PrepareSkillThrowDialog({
    super.key,
    required this.actors,
  });

  final List<EntityBase> actors;

  @override
  State<PrepareSkillThrowDialog> createState() => _PrepareSkillThrowDialogState();
}

class _PrepareSkillThrowDialogState extends State<PrepareSkillThrowDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Attribute? attribute;
  bool setDifficulty = true;
  int difficulty = 15;
  bool isOpposition = false;
  DiceThrowRequestType requestType = DiceThrowRequestType.simple;
  EntityBase? opposing;
  int? opposingDifficulty;
  DiceThrowEntityBase? opposingBase;
  Ability? fallbackAbility;

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
                  child: PrepareOppositionThrowWidget(
                    actor: widget.actors.first,
                    onEntitySelected: (EntityBase e) {
                      setState(() {
                        opposing = e;
                      });
                    },
                    initialDifficulty: difficulty,
                    onDifficultyChanged: (int? v) {
                      opposingDifficulty = v;
                    },
                    onBaseSelected: (DiceThrowEntityBase? b) {
                      opposingBase = b;
                    },
                    onFallbackAbilitySelected: (Ability? a) {
                      fallbackAbility = a;
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
              PrepareSkillThrowResult(
                attribute: attribute!,
                difficulty: setDifficulty ? difficulty : null,
                requestType: requestType,
                opposing: opposing,
                opposingDifficulty: opposingDifficulty,
                opposingBase: opposingBase,
                fallbackAbility: fallbackAbility,
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