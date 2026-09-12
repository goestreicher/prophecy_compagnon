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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/character_role.dart';
import 'package:prophecy_compagnon_shared/ui/markdown_display_widget.dart';

class CharacterRoleDisplayWidget extends StatelessWidget {
  const CharacterRoleDisplayWidget({ super.key, required this.member });

  final CharacterRole member;

  @override
  Widget build(BuildContext context) {
    var title = member.title.isNotEmpty ? ', ${member.title}' : '';
    if(member.name != null) {
      return Text(
          '${member.name}$title'
      );
    }
    else if(member.link != null) {
      return MarkdownDisplayWidget(
        data: '[${member.link!.name}$title](${member.link!.link})',
      );
    }
    else {
      return Text('Nom de dirigeant invalide');
    }
  }
}