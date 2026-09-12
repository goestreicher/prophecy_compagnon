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

import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';

enum MagicSkill {
  instinctive(title: "Magie instinctive", ability: Ability.empathie),
  invocatoire(title: "Magie invocatoire", ability: Ability.perception),
  sorcellerie(title: "Sorcellerie", ability: Ability.intelligence);

  const MagicSkill({
    required this.title,
    required this.ability,
  });

  final String title;
  final Ability ability;
}

enum MagicSphere {
  pierre(title: "La Pierre"),
  feu(title: "Le Feu"),
  oceans(title: "Les Océans"),
  metal(title: "Le Métal"),
  nature(title: "La Nature"),
  reves(title: "Les Rêves"),
  cite(title: "La Cité"),
  vents(title: "Les Vents"),
  ombre(title: "L'Ombre");

  const MagicSphere({
    required this.title,
  });

  final String title;
}