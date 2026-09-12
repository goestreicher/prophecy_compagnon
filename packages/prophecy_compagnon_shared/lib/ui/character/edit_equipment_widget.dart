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
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/edit_armor_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/edit_clothes_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/edit_jewels_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/edit_misc_gear_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/edit_money_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/edit_weapons_widget.dart';

class CharacterEditEquipmentWidget extends StatelessWidget {
  const CharacterEditEquipmentWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [
        EntityEditMoneyWidget(
          entity: character,
        ),
        EntityEditWeaponsWidget(
          entity: character,
        ),
        EntityEditArmorWidget(
          entity: character,
        ),
        EntityEditClothesWidget(
          entity: character,
        ),
        EntityEditJewelsWidget(
          entity: character,
        ),
        EntityEditMiscGearWidget(
          entity: character,
        ),
      ],
    );
  }
}