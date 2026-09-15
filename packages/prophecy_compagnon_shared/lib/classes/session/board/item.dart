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

import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/classes/session/session_context_retriever.dart';

typedef SessionBoardItemJsonFactory = SessionBoardItem Function(
    Map<String, dynamic>,
    SessionContextRetriever
  );

abstract class SessionBoardItem {
  SessionBoardItem({
    required this.title,
    this.removable = true,
  });

  final String title;
  final bool removable;

  Future<GenericImage> thumbnail(double maxDimension);
  GenericImage image();
  Map<String, dynamic> boardItemToJson();

  factory SessionBoardItem.fromJson(
      Map<String, dynamic> json,
      SessionContextRetriever context,
  ) {
    if(!json.containsKey('_type')) {
      throw(ArgumentError('Missing "_type" key in JSON'));
    }
    return _boardItemFactories[json['_type']]!(json, context);
  }

  Map<String, dynamic> toJson() {
    var ret = boardItemToJson();
    ret['_type'] = runtimeType.toString();
    return ret;
  }

  static void registerSessionBoardItemJsonFactory(String name, SessionBoardItemJsonFactory factory) =>
      _boardItemFactories[name] = factory;

  static final Map<String, SessionBoardItemJsonFactory> _boardItemFactories =
      <String, SessionBoardItemJsonFactory>{};
}