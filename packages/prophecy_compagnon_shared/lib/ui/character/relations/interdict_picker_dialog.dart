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
import 'package:prophecy_compagnon_shared/classes/caste/interdicts.dart';

class InterdictPickerDialog extends StatefulWidget {
  const InterdictPickerDialog({ super.key, this.defaultCaste });

  final Caste? defaultCaste;

  @override
  State<InterdictPickerDialog> createState() => _InterdictPickerDialogState();
}

class _InterdictPickerDialogState extends State<InterdictPickerDialog> {
  final TextEditingController casteController = TextEditingController();
  final TextEditingController interdictController = TextEditingController();

  Caste? currentCaste;
  final List<CasteInterdict> interdictsForCurrentCaste = <CasteInterdict>[];
  CasteInterdict? interdict;

  void updateForCurrentCaste() {
    interdict = null;
    interdictsForCurrentCaste.clear();
    interdictController.clear();
    if(currentCaste == null) return;
    interdictsForCurrentCaste.addAll(
      CasteInterdict.values.where((CasteInterdict i) => i.caste == currentCaste)
    );
  }

  @override
  void initState() {
    super.initState();
    currentCaste = widget.defaultCaste;
    updateForCurrentCaste();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
        title: const Text("Sélectionner l'interdit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Row(
                spacing: 16.0,
                children: [
                  SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16.0,
                      children: [
                        DropdownMenu(
                          controller: casteController,
                          initialSelection: currentCaste,
                          label: const Text('Caste'),
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (Caste? caste) {
                            setState(() {
                              currentCaste = caste;
                              updateForCurrentCaste();
                            });
                          },
                          dropdownMenuEntries: Caste.values
                            .where((Caste c) => c != Caste.sansCaste)
                            .map((Caste c) => DropdownMenuEntry(value: c, label: c.title))
                            .toList(),
                        ),
                        DropdownMenu(
                          controller: interdictController,
                          label: const Text('Interdit'),
                          requestFocusOnTap: true,
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (CasteInterdict? i) {
                            setState(() {
                              interdict = i;
                            });
                          },
                          dropdownMenuEntries: interdictsForCurrentCaste
                            .map((CasteInterdict i) => DropdownMenuEntry(value: i, label: i.title))
                            .toList(),
                        ),
                      ],
                    ),
                  ),
                  if(interdict != null && interdict!.description.isNotEmpty)
                    SingleChildScrollView(
                      child: UnconstrainedBox(
                        child: Container(
                          padding: EdgeInsets.only(right: 16.0),
                          width: 300,
                          child: Text(
                            interdict!.description,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
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
                    onPressed: interdict == null ? null : () {
                      Navigator.of(context).pop(interdict);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  )
                ],
              )
            ),
          ],
        )
    );
  }
}