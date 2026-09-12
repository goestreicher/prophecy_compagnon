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
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EquipmentRequirementsEditWidget extends StatefulWidget {
  const EquipmentRequirementsEditWidget({
    super.key,
    required this.onChanged,
    this.requirements,
  });

  final void Function(Map<Ability, int>) onChanged;
  final Map<Ability, int>? requirements;

  @override
  State<EquipmentRequirementsEditWidget> createState() => _EquipmentRequirementsEditWidgetState();
}

class _EquipmentRequirementsEditWidgetState extends State<EquipmentRequirementsEditWidget> {
  Map<Ability, int> requirements = <Ability, int>{};
  bool isAdding = false;

  @override
  void initState() {
    super.initState();

    if(widget.requirements != null) {
      requirements = Map<Ability, int>.of(widget.requirements!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Pré-requis',
        style: theme.textTheme.bodySmall!.copyWith(
          color: Colors.black87,
        )
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 150,
        ),
        child: Align(
          alignment: AlignmentGeometry.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.0,
            children: [
              if(requirements.isEmpty && !isAdding)
                const Text('Aucun pré-requis'),
              for(var a in requirements.keys)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          requirements.remove(a);
                          widget.onChanged(requirements);
                        });
                      },
                      icon: const Icon(Icons.delete),
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(4.0),
                      constraints: const BoxConstraints(),
                    ),
                    Text(
                      '${a.short}: ${requirements[a]!}'
                    ),
                  ],
                ),
              if(isAdding)
                _AddRequirementWidget(
                  excludedAbilities: requirements.keys.toList(),
                  onDone: (Ability a, int v) {
                    requirements[a] = v;
                    widget.onChanged(requirements);
                    setState(() {
                      isAdding = false;
                    });
                  },
                  onCanceled: () {
                    setState(() {
                      isAdding = false;
                    });
                  }
                ),
              if(!isAdding)
                IconButton(
                  onPressed: () {
                    setState(() {
                      isAdding = true;
                    });
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 24.0,
                  padding: const EdgeInsets.all(4.0),
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddRequirementWidget extends StatefulWidget {
  const _AddRequirementWidget({
    required this.onDone,
    required this.onCanceled,
    this.excludedAbilities = const <Ability>[],
  });

  final void Function(Ability, int) onDone;
  final void Function() onCanceled;
  final List<Ability> excludedAbilities;

  @override
  State<_AddRequirementWidget> createState() => _AddRequirementWidgetState();
}

class _AddRequirementWidgetState extends State<_AddRequirementWidget> {
  Ability? ability;
  int value = 1;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 12.0,
      children: [
        SizedBox(
          width: 100,
          child: DropdownMenuFormField<Ability>(
            requestFocusOnTap: true,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: Ability.values
              .where((Ability a) => !widget.excludedAbilities.contains(a))
              .map((Ability a) => DropdownMenuEntry(value: a, label: a.short))
              .toList(),
            onSelected: (Ability? a) {
              if(a == null) return;
              setState(() {
                ability = a;
              });
            },
          ),
        ),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            initialValue: 1,
            minValue: 1,
            maxValue: 30,
            onChanged: (int v) {
              setState(() {
                value = v;
              });
            },
          ),
        ),
        IconButton(
          onPressed: () {
            widget.onCanceled();
          },
          icon: const Icon(Icons.cancel_outlined),
          iconSize: 18.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: ability == null ? null : () {
            widget.onDone(ability!, value);
          },
          icon: const Icon(Icons.check_circle_outline),
          iconSize: 18.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}