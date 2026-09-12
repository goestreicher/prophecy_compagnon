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

import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

enum CombatActionType {
  effect(title: 'Effet', icon: Symbols.deblur),
  movement(title: 'Mouvement', icon: Symbols.arrows_output),
  // attack(title: 'Attaque', icon: Icons.cancel_outlined),
  // defense(title: 'Défense', icon: Icons.cancel_outlined),
  // effect(title: 'Effet', icon: Icons.cancel_outlined),
  ;

  final String title;
  final IconData icon;

  const CombatActionType({ required this.title, required this.icon });
}