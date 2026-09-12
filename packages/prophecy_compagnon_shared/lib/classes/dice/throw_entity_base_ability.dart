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

import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';

class DiceThrowEntityBaseAbility extends DiceThrowEntityBase {
  DiceThrowEntityBaseAbility({
    required super.attribute,
    required this.ability,
  });

  final Ability ability;

  @override
  String get label => '${attribute.title} + ${ability.title}';

  @override
  String componentLabel(EntityBase entity) => ability.title;

  @override
  int componentValue(EntityBase entity) => entity.abilities[ability];

  @override
  int value(EntityBase entity) {
    // TODO: manage bonuses
    return entity.attributes[attribute] + entity.abilities[ability];
  }
}