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
import 'package:prophecy_compagnon_mj/ui/session/character/info.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:provider/provider.dart';

class PlayCharactersPage extends StatelessWidget {
  const PlayCharactersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var session = context.read<GameSession>();

    var pcWidgets = <Widget>[];
    for(var pc in session.table.players) {
      pcWidgets.add(
        SessionCharacterInfoWidget(
          character: pc,
        )
      );
    }

    return SingleChildScrollView(
      child: Column(
        spacing: 12.0,
        children: pcWidgets,
      ),
    );
  }
}