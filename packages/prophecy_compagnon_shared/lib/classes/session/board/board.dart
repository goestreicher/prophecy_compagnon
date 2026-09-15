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

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/session_context_retriever.dart';

class SessionGameBoard with IterableMixin<SessionBoardItem>, ChangeNotifier {
  SessionGameBoard({
    List<SessionBoardItem>? items,
    int? selected,
  })
    : _board = items ?? <SessionBoardItem>[],
      _selected = selected;

  @override
  Iterator<SessionBoardItem> get iterator =>
      _board.iterator;

  void push(SessionBoardItem item) =>
      insert(0, item);

  void insert(int index, SessionBoardItem item) {
    _board.insert(index, item);
    _selected = index;
    notifyListeners();
  }

  void removeAt(int index) {
    if(index == _selected) {
      if(_board.length == 1) {
        _selected = null;
      }
      else if(index == _board.length - 1) {
        _selected = index - 1;
      }
    }
    _board.removeAt(index);
    notifyListeners();
  }

  int? get selected => _selected;
  set selected(int? v) {
    _selected = v;
    notifyListeners();
  }
  int? _selected;

  factory SessionGameBoard.fromJson(
      Map<String, dynamic> json,
      SessionContextRetriever context,
  ) {
    return SessionGameBoard(
      items: (json['items'] as List<Map<String, dynamic>>? ?? <Map<String, dynamic>>[])
          .map((Map<String, dynamic> m) => SessionBoardItem.fromJson(m, context))
          .toList(),
      selected: json['selected'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'items': _board
            .map((SessionBoardItem i) => i.toJson())
            .toList(),
        'selected': _selected,
      };

  final List<SessionBoardItem> _board;
}