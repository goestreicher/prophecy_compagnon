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

import 'package:prophecy_compagnon_shared/classes/entity_base.dart';

abstract class DiceThrowEntityBase {
  DiceThrowEntityBase();

  bool canThrow(EntityBase entity) => true;

  String get label;
  int value(EntityBase entity);

  String baseLabel(EntityBase entity);
  int baseValue(EntityBase entity);

  String componentLabel(EntityBase entity);
  int componentValue(EntityBase entity);

  String difficultyModifierLabel(EntityBase entity) => '';
  int difficultyModifier(EntityBase entity) => 0;
}