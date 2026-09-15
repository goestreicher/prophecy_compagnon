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

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class RegisterSessionBoardItemsGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    var lines = <String>[];

    for(var element in library.classes) {
      if(!element.isPublic) continue;
      if(element.isAbstract) continue;

      var isBoardItem = false;
      for(var interfaceType in element.allSupertypes) {
        if(interfaceType.getDisplayString() == 'SessionBoardItem') isBoardItem = true;
      }
      if(!isBoardItem) continue;

      lines.add(
        '  SessionBoardItem.registerSessionBoardItemJsonFactory(\n'
        '    "${element.name}",\n'
        '    (\n'
        '        Map<String, dynamic> json,\n'
        '        SessionContextRetriever context\n'
        '    ) => ${element.name}.fromJson(json, context),\n'
        '  );\n'
      );
    }

    return lines.join('\n');
  }
}