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
import 'package:prophecy_compagnon_mj/ui/session/character/menus/prepare_skill_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/ability.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';

class AbilityThrowMenuWidget extends StatefulWidget {
  const AbilityThrowMenuWidget({
    super.key,
    required this.entities,
  });

  final List<EntityBase> entities;

  @override
  State<AbilityThrowMenuWidget> createState() => _AbilityThrowMenuWidgetState();
}

class _AbilityThrowMenuWidgetState extends State<AbilityThrowMenuWidget> {
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
            var result = await showDialog<PrepareSkillThrowResult>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PrepareSkillThrowDialog(
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