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
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/misc_gear.dart';

class MiscGearPickerDialog extends StatefulWidget {
  const MiscGearPickerDialog({ super.key });

  @override
  State<MiscGearPickerDialog> createState() => _MiscGearPickerDialogState();
}

class _MiscGearPickerDialogState extends State<MiscGearPickerDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<MiscGearModel> items = <MiscGearModel>[];
  MiscGearModel? model;
  EquipmentMetal metal = EquipmentMetal.none;
  TextEditingController aliasController = TextEditingController();
  EquipmentQuality quality = EquipmentQuality.normal;
  
  @override
  void initState() {
    super.initState();
    
    for(var mgid in MiscGearModel.ids()) {
      var item = MiscGearModel.get(mgid);
      if(item == null) continue;
      items.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choisir l'équipement"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            DropdownMenuFormField<MiscGearModel>(
              requestFocusOnTap: true,
              label: const Text('Équipement'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: items
                .map((MiscGearModel mg) => DropdownMenuEntry(value: mg, label: mg.name))
                .toList(),
              validator: (MiscGearModel? mg) {
                if(mg == null) return 'Valeur manquante';
                return null;
              },
              onSelected: (MiscGearModel? mg) {
                setState(() {
                  model = mg;
                  metal = model?.supportsMetal ?? false
                    ? EquipmentMetal.iron
                    : EquipmentMetal.none;
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
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () async {
            if(!formKey.currentState!.validate()) return;

            var mg = MiscGear.create(
              model: model!,
              alias: aliasController.text.isEmpty ? null : aliasController.text,
              quality: quality,
              metal: metal,
            );
            Navigator.of(context).pop(mg);
          },
        )
      ],
    );
  }
}