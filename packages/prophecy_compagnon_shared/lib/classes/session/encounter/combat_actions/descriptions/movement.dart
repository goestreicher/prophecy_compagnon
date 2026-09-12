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
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_description.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/action_configuration.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/run.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/simple.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/sprint.dart';

enum CombatActionMovementType {
  simple(title: 'Déplacement simple', icon: Icons.directions_walk),
  run(title: 'Course', icon: Icons.directions_run),
  sprint(title: 'Sprint', icon: Symbols.sprint),
  ;

  final String title;
  final IconData icon;

  const CombatActionMovementType({ required this.title, required this.icon });
}

class CombatActionMovementDescription extends CombatActionDescription {
  CombatActionMovementDescription({
    required this.movementType,
  })
    : super(type: CombatActionType.movement);

  CombatActionMovementType movementType;

  @override
  ActionConfiguration instantiate() {
    ActionConfiguration ret;

    switch(movementType) {
      case CombatActionMovementType.simple:
        ret = ActionConfigurationMovementSimple();
      case CombatActionMovementType.run:
        ret = ActionConfigurationMovementRun();
      case CombatActionMovementType.sprint:
        ret = ActionConfigurationMovementSprint();
        break;
    }

    return ret;
  }
}