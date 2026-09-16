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

import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_actions/descriptions/movement.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/action_configuration.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/get_up.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/run.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/simple.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/definition/movement/sprint.dart';

ActionConfiguration? instantiateMovementActionConfiguration(CombatActionMovementDescription description) {
  ActionConfiguration? ret;

  switch(description.movementType) {
    case CombatActionMovementType.simple:
      ret = ActionConfigurationMovementSimple();
    case CombatActionMovementType.run:
      ret = ActionConfigurationMovementRun();
    case CombatActionMovementType.sprint:
      ret = ActionConfigurationMovementSprint();
    case CombatActionMovementType.getUp:
      ret = ActionConfigurationMovementGetUp();
  }

  return ret;
}