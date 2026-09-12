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

import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';

enum SkillFamily {
  combat(title: "Combat", defaultAttribute: Attribute.physique),
  mouvement(title: "Mouvement", defaultAttribute: Attribute.physique),
  theorie(title: "Théorie", defaultAttribute: Attribute.mental),
  pratique(title: "Pratique", defaultAttribute: Attribute.mental),
  technique(title: "Technique", defaultAttribute: Attribute.manuel),
  manipulation(title: "Manipulation", defaultAttribute: Attribute.manuel),
  communication(title: "Communication", defaultAttribute: Attribute.social),
  influence(title: "Influence", defaultAttribute: Attribute.social);

  const SkillFamily({
    required this.title,
    required this.defaultAttribute,
  });

  final String title;
  final Attribute defaultAttribute;
}