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
import 'package:flutter/services.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class ScarcityEditWidget extends StatefulWidget {
  const ScarcityEditWidget({
    super.key,
    required this.type,
    required this.onScarcityChanged,
    required this.onPriceChanged,
    this.scarcity,
    this.price,
  });

  final String type;
  final void Function(EquipmentScarcity) onScarcityChanged;
  final void Function(int) onPriceChanged;
  final EquipmentScarcity? scarcity;
  final int? price;

  @override
  State<ScarcityEditWidget> createState() => _ScarcityEditWidgetState();
}

class _ScarcityEditWidgetState extends State<ScarcityEditWidget> {
  TextEditingController scarcityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.price != null) priceController.text = widget.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        widget.type,
        style: theme.textTheme.bodySmall!.copyWith(
          color: Colors.black87,
        )
      ),
      child: Column(
        spacing: 12.0,
        children: [
          DropdownMenuFormField<EquipmentScarcity>(
            initialSelection: widget.scarcity,
            requestFocusOnTap: true,
            label: const Text('Rareté'),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: EquipmentScarcity.values
              .map((EquipmentScarcity s) => DropdownMenuEntry(value: s, label: s.title))
              .toList(),
            validator: (EquipmentScarcity? s) {
              if(s == null) return 'Valeur manquante';
              return null;
            },
            onSelected: (EquipmentScarcity? s) {
              if(s == null) return;
              widget.onScarcityChanged(s);
            },
          ),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Prix (df)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (String? value) {
              if(value == null || value.isEmpty) return 'Valeur manquante';
              int? input = int.tryParse(value);
              if(input == null) return 'Pas un nombre';
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (String? value) {
              if(value == null || value.isEmpty) return;
              int? input = int.tryParse(value);
              if(input == null) return;
              widget.onPriceChanged(input);
            },
          ),
        ],
      )
    );
  }
}