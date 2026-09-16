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
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/ui/session/encounter/action_configuration/action_configuration.dart';

class ActionConfigurationMenuRenderer extends StatelessWidget {
  const ActionConfigurationMenuRenderer({
    super.key,
    required this.action,
    required this.actionConfiguration,
  });

  final SessionEncounterEntityAction action;
  final ActionConfiguration actionConfiguration;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return MenuItemButton(
      leadingIcon: Icon(
        actionConfiguration.icon,
        size: 18.0,
      ),
      onPressed: () {
        actionConfiguration.plan(action);
      },
      child: Text(
        actionConfiguration.name,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}