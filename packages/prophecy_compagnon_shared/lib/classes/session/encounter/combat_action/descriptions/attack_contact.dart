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
import 'package:prophecy_compagnon_shared/ui/custom_icons.dart';

enum CombatActionAttackContactType {
  simple(title: "Attaque simple", icon: CustomIcons.punch),
  brutal(title: "Attaque brutale", icon: CustomIcons.punchBrutal),
  precise(title: "Attaque précise", icon: CustomIcons.punchPrecise),
  // stun(title: "Assomer", icon: CustomIcons.punch),
  // incapacitate(title: "Incapaciter", icon: CustomIcons.punch),
  // topple(title: "Renverser", icon: CustomIcons.punch),
  // crush(title: "Écraser", icon: CustomIcons.punch),
  // grapple(title: "Saisir", icon: CustomIcons.punch),
  ;

  final String title;
  final IconData icon;

  const CombatActionAttackContactType({ required this.title, required this.icon });
}