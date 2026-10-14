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
import 'package:prophecy_compagnon_mj/ui/session/character/menus/skill_throw_common.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';
import 'package:prophecy_compagnon_shared/ui/session/entity_dice_throw_dialog.dart';

class SkillThrowMenuWidget extends StatefulWidget {
  const SkillThrowMenuWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  State<SkillThrowMenuWidget> createState() => _SkillThrowMenuWidgetState();
}

class _SkillThrowMenuWidgetState extends State<SkillThrowMenuWidget> {
  SkillThrowWrapper? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var entries = <DropdownMenuEntry<SkillThrowWrapper>>[];
    for(var family in SkillFamily.values) {
      var familyEntries = <DropdownMenuEntry<SkillThrowWrapper>>[];

      for(var skill in widget.entity.skills.forFamily(family)) {
        familyEntries.add(
          DropdownMenuEntry(
            value: StandardSkillThrowWrapper(
              skill: skill.skill,
              implementation: skill.implementation,
            ),
            label: skill.title,
          )
        );

        for(var specialization in skill.specializations) {
          familyEntries.add(
            DropdownMenuEntry(
              value: SpecializationSkillThrowWrapper(
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
            value: SeparatorSkillThrowWrapper(),
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
            onSelected: (SkillThrowWrapper? w) {
              setState(() {
                selected = w;
              });
            },
            dropdownMenuEntries: entries,
          ),
        ),
        IconButton(
          onPressed: selected == null ? null : () async {
            var result = await showDialog<PrepareSkillThrowResult>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PrepareSkillThrowDialog(
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
                SkillThrowWrapperToBaseArgs(
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
              ),
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