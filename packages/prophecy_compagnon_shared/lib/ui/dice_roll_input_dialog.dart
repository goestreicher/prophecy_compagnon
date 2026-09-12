/*
 * Copyright (C) 2024-2026 Grégory Oestreicher
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
import 'package:prophecy_compagnon_shared/ui/dice_roll_input.dart';

class DiceRollInputDialog extends StatefulWidget {
  const DiceRollInputDialog({
    super.key,
    this.title,
    this.text,
    required this.count
  });

  final String? title;
  final String? text;
  final int count;

  @override
  State<DiceRollInputDialog> createState() => _DiceRollInputDialogState();
}

class _DiceRollInputDialogState extends State<DiceRollInputDialog> {
  late List<int> results;

  @override
  void initState() {
    super.initState();

    results = List.generate(widget.count, (index) => 0);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var subtitleWidgets = <Widget>[];

    if(widget.text != null && widget.text!.isNotEmpty) {
      subtitleWidgets.addAll([
        Text(widget.text!),
        const SizedBox(height: 8.0),
      ]);
    }

    return AlertDialog(
      title: Text(widget.title ?? 'Jet de dé'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...subtitleWidgets,
          Row(
            children: [
              for(var idx = 0; idx < widget.count; ++idx)
                DiceRollInputWidget(
                  onValueSelected: (int v) {
                    results[idx] = v;
                  }
                ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      if(!results.every((int r) => r > 0)) return;

                      Navigator.of(context).pop(results);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}