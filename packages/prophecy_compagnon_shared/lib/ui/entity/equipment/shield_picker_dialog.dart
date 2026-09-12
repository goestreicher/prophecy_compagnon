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
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/shield.dart';

class ShieldPickerDialog extends StatefulWidget {
  const ShieldPickerDialog({ super.key });

  @override
  State<ShieldPickerDialog> createState() => _ShieldPickerDialogState();
}

class _ShieldPickerDialogState extends State<ShieldPickerDialog> {
  final TextEditingController shieldController = TextEditingController();
  final Map<String, String> shields = <String, String>{};
  ShieldModel? model;
  EquipmentMetal metal = EquipmentMetal.none;
  EquipmentQuality quality = EquipmentQuality.normal;
  final TextEditingController aliasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    for(var id in ShieldModel.ids()) {
      shields[id] = ShieldModel.get(id)!.name;
    }

    return AlertDialog(
      title: const Text('Sélectionner le bouclier'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: [
          DropdownMenu(
            controller: shieldController,
            requestFocusOnTap: true,
            label: const Text('Bouclier'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: shields.keys
              .map((String id) => DropdownMenuEntry(value: id, label: shields[id]!))
              .toList(),
            onSelected: (String? id) {
              setState(() {
                if(id == null) {
                  model = null;
                }
                else {
                  model = ShieldModel.get(id);
                  metal = model?.supportsMetal ?? false
                    ? EquipmentMetal.iron
                    : EquipmentMetal.none;
                }
              });
            },
          ),
          if(model?.supportsMetal ?? false)
            DropdownMenuFormField<EquipmentMetal>(
              initialSelection: EquipmentMetal.iron,
              requestFocusOnTap: true,
              label: const Text('Métal'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: EquipmentMetal.values
                .map((EquipmentMetal m) => DropdownMenuEntry(value: m, label: m.title))
                .toList(),
              validator: (EquipmentMetal? m) {
                if(m == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (EquipmentMetal? m) {
                if(m == null) return;
                metal = m;
              },
            ),
          DropdownMenuFormField<EquipmentQuality>(
            initialSelection: quality,
            requestFocusOnTap: true,
            label: const Text('Qualité'),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: EquipmentQuality.values
              .map((EquipmentQuality q) => DropdownMenuEntry(value: q, label: q.title))
              .toList(),
            validator: (EquipmentQuality? q) {
              if(q == null) return 'Valeur manquante';
              return null;
            },
            onSelected: (EquipmentQuality? q) {
              if(q == null) return;
              quality = q;
            },
          ),
          TextField(
            controller: aliasController,
            decoration: InputDecoration(
              labelText: 'Alias',
              border: OutlineInputBorder(),
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
                  onPressed: () {
                    if(model == null) return;

                    var shield = Shield.create(
                      model: model!,
                      alias: aliasController.text.isEmpty ? null : aliasController.text,
                      quality: quality,
                      metal: metal,
                    );
                    Navigator.of(context).pop(shield);
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
      ),
    );
  }
}