/*
 * Copyright (C) 2025-2026 Grégory Oestreicher
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
import 'package:prophecy_compagnon_shared/classes/caste/base.dart';
import 'package:prophecy_compagnon_shared/classes/character/advantages.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/character/background/advantage_select_widget.dart';

class AdvantagePickerDialog extends StatefulWidget {
  const AdvantagePickerDialog({
    super.key,
    this.types,
    this.maxCost,
    this.exclude,
    this.includeReservedForCaste,
  });

  final List<AdvantageType>? types;
  final int? maxCost;
  final List<Advantage>? exclude;
  final Caste? includeReservedForCaste;

  @override
  State<AdvantagePickerDialog> createState() => _AdvantagePickerDialogState();
}

class _AdvantagePickerDialogState extends State<AdvantagePickerDialog> {
  CharacterAdvantage? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Sélectionner l'avantage"),
      content: SizedBox(
        width: 800,
        height: 500,
        child: AdvantageSelectWidget(
          types: (widget.types ?? AdvantageType.values),
          maxCost: widget.maxCost,
          exclude: widget.exclude,
          includeReservedForCaste: widget.includeReservedForCaste,
          onSelected: (CharacterAdvantage? a) {
            setState(() {
              selected = a;
            });
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: selected == null ? null : () {
            Navigator.of(context).pop(selected!);
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