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
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/action_initializer.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';

class ActionConfigurationMenuRenderer extends StatelessWidget {
  const ActionConfigurationMenuRenderer({
    super.key,
    required this.action,
    required this.initializer,
    required this.actionBuildContext,
  });

  final SessionEncounterEntityAction action;
  final ActionInitializer initializer;
  final BuildContext actionBuildContext;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return MenuItemButton(
      leadingIcon: Icon(
        initializer.icon,
        size: 18.0,
      ),
      onPressed: () {
        initializer.plan(actionBuildContext, action);
      },
      child: Text(
        initializer.name,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}