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
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';

class DiceThrowMenuItem {
  const DiceThrowMenuItem({
    required this.label,
    required this.request,
    this.canChangeDifficulty = true,
    this.difficultyHints,
    this.contextModifierHints,
    this.canUseProficiency = true,
    this.canUseTendencies = true,
    this.canUseLuck = true,
  });

  final String label;
  final DiceThrowRequest request;
  final bool canChangeDifficulty;
  final Map<String, int>? difficultyHints;
  final List<String>? contextModifierHints;
  final bool canUseProficiency;
  final bool canUseTendencies;
  final bool canUseLuck;
}

class DiceThrowMenuWidget extends StatefulWidget {
  const DiceThrowMenuWidget({
    super.key,
    required this.entities,
    required this.items,
  });

  final List<EntityBase> entities;
  final List<DiceThrowMenuItem> items;

  @override
  State<DiceThrowMenuWidget> createState() => _DiceThrowMenuWidgetState();
}

class _DiceThrowMenuWidgetState extends State<DiceThrowMenuWidget> {
  DiceThrowMenuItem? selected;

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
              'Jets',
            ),
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            onSelected: (DiceThrowMenuItem? i) {
              setState(() {
                selected = i;
              });
            },
            dropdownMenuEntries: widget.items.map(
                (DiceThrowMenuItem i) => DropdownMenuEntry(value: i, label: i.label)
              )
              .toList(),
          ),
          IconButton(
            onPressed: widget.entities.isEmpty || selected == null ? null : () async {
              var bundles = await showDialog<List<EntityThrowBundle>>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => EntityDiceThrowDialog(
                  entities: widget.entities,
                  request: selected!.request,
                  canChangeDifficulty: selected!.canChangeDifficulty,
                  difficultyHints: selected!.difficultyHints,
                  contextModifierHints: selected!.contextModifierHints,
                  canUseProficiency: selected!.canUseProficiency,
                  canUseTendencies: selected!.canUseTendencies,
                  canUseLuck: selected!.canUseLuck,
                )
              );
              if(bundles == null || bundles.isEmpty) return;
              if(!context.mounted) return;

              for(var bundle in bundles) {
                switch(selected!.request.type) {
                  case DiceThrowRequestType.raw:
                    break;
                  case DiceThrowRequestType.threshold:
                  case DiceThrowRequestType.simple:
                    var evaluation = evaluateDiceThrow(bundle);
                  case DiceThrowRequestType.oppositionDirect:
                  case DiceThrowRequestType.oppositionNR:
                    // TODO: manage opposition throws
                    break;
                }
              }
            },
            icon: Icon(CustomIcons.d10),
          ),
        ],
      ),
    );
  }
}