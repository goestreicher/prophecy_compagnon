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
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';

class CombatWeaponSelectionDialog extends StatefulWidget {
  const CombatWeaponSelectionDialog({ super.key, required this.weapons });

  final List<Weapon> weapons;

  @override
  State<CombatWeaponSelectionDialog> createState() => _CombatWeaponSelectionDialogState();
}

class _CombatWeaponSelectionDialogState extends State<CombatWeaponSelectionDialog> {
  final TextEditingController _controller = TextEditingController();
  Weapon? selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Choix de l'arme"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownMenu(
            controller: _controller,
            requestFocusOnTap: true,
            initialSelection: widget.weapons.first,
            onSelected: (Weapon? w) => selected = w,
            dropdownMenuEntries: widget.weapons
              .map((Weapon w) => DropdownMenuEntry(value: w, label: w.model.name))
              .toList(),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(selected == null) return;
                    Navigator.of(context).pop(selected);
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
      )
    );
  }
}